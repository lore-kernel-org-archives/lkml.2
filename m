Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0I2QbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 12:31:09 -0400
Received: from fieldses.org ([174.143.236.118]:45827 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab0I2QbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 12:31:07 -0400
Date: Wed, 29 Sep 2010 12:30:55 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (Was:
 linux-next: build warning after merge of the final tree)
Message-ID: <20100929163055.GC17087@fieldses.org>
References: <20100929140238.c987caac.sfr@canb.auug.org.au>
 <20100929141657.3c076eb7.sfr@canb.auug.org.au>
 <4CA322DA.90705@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA322DA.90705@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 03:28:26PM +0400, Pavel Emelyanov wrote:
> > This actually causes a build failure on a sparc32 defconfig build:
> > 
> > `rpcauth_remove_module' referenced in section `.init.text' of net/built-in.o: defined in discarded section `.exit.text' of net/built-in.o
> > 
> > I applied the following patch for today:
> > 
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Wed, 29 Sep 2010 14:07:07 +1000
> > Subject: [PATCH] sunrpc: fix up section mismatch
> > 
> > Fixes:
> > 
> > `rpcauth_remove_module' referenced in section `.init.text' of net/built-in.o: defined in discarded section `.exit.text' of net/built-in.o
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> Oops :(
> 
> Acked-by: Pavel Emelyanov <xemul@openvz.org>

Thanks, applied, and I'll push that out soon.

--b.

> 
> > ---
> >  include/linux/sunrpc/auth.h |    4 ++--
> >  net/sunrpc/auth.c           |    2 +-
> >  net/sunrpc/auth_generic.c   |    2 +-
> >  3 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/sunrpc/auth.h b/include/linux/sunrpc/auth.h
> > index 5bbc447..b202475 100644
> > --- a/include/linux/sunrpc/auth.h
> > +++ b/include/linux/sunrpc/auth.h
> > @@ -122,8 +122,8 @@ extern const struct rpc_authops	authnull_ops;
> >  int __init		rpc_init_authunix(void);
> >  int __init		rpc_init_generic_auth(void);
> >  int __init		rpcauth_init_module(void);
> > -void __exit		rpcauth_remove_module(void);
> > -void __exit		rpc_destroy_generic_auth(void);
> > +void			rpcauth_remove_module(void);
> > +void			rpc_destroy_generic_auth(void);
> >  void 			rpc_destroy_authunix(void);
> >  
> >  struct rpc_cred *	rpc_lookup_cred(void);
> > diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
> > index e9eaaf7..2c0d9e6 100644
> > --- a/net/sunrpc/auth.c
> > +++ b/net/sunrpc/auth.c
> > @@ -658,7 +658,7 @@ out1:
> >  	return err;
> >  }
> >  
> > -void __exit rpcauth_remove_module(void)
> > +void rpcauth_remove_module(void)
> >  {
> >  	rpc_destroy_authunix();
> >  	rpc_destroy_generic_auth();
> > diff --git a/net/sunrpc/auth_generic.c b/net/sunrpc/auth_generic.c
> > index 43162bb..e010a01 100644
> > --- a/net/sunrpc/auth_generic.c
> > +++ b/net/sunrpc/auth_generic.c
> > @@ -158,7 +158,7 @@ int __init rpc_init_generic_auth(void)
> >  	return rpcauth_init_credcache(&generic_auth);
> >  }
> >  
> > -void __exit rpc_destroy_generic_auth(void)
> > +void rpc_destroy_generic_auth(void)
> >  {
> >  	rpcauth_destroy_credcache(&generic_auth);
> >  }
> 
