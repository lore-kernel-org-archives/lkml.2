Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab2D0A5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 20:57:17 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:58418 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2D0A5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 20:57:16 -0400
Date: Fri, 27 Apr 2012 09:57:13 +0900
From: Simon Horman <horms@verge.net.au>
To: Julian Anastasov <ja@ssi.bg>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] IPVS: ip_vs_sync.c: local functions should not be
 exposed globally
Message-ID: <20120427005713.GC5105@verge.net.au>
References: <201204261129.53927.hartleys@visionengravers.com>
 <alpine.LFD.2.00.1204262301160.2078@ja.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1204262301160.2078@ja.ssi.bg>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 11:11:54PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Thu, 26 Apr 2012, H Hartley Sweeten wrote:
> 
> > Functions not referenced outside of a source file should be marked
> > static to prevent it from being exposed globally.
> > 
> > This quiets the sparse warnings:
> > 
> > warning: symbol 'ip_vs_sync_conn_v0' was not declared. Should it be static?
> > 
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > 
> > ---
> > 
> > diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> > index bf5e538..49a1fe8 100644
> > --- a/net/netfilter/ipvs/ip_vs_sync.c
> > +++ b/net/netfilter/ipvs/ip_vs_sync.c
> > @@ -446,7 +446,7 @@ ip_vs_sync_buff_create_v0(struct netns_ipvs *ipvs)
> >   *      Version 0 , could be switched in by sys_ctl.
> >   *      Add an ip_vs_conn information into the current sync_buff.
> >   */
> > -void ip_vs_sync_conn_v0(struct net *net, struct ip_vs_conn *cp)
> > +static void ip_vs_sync_conn_v0(struct net *net, struct ip_vs_conn *cp)
> 
> 	The 3 patches for IPVS look correct but this change
> is already not needed after one of our planned changes:
> 
> "ipvs: reduce sync rate with time thresholds"
> 
> 	Not sure how we will avoid the collision, may be
> Simon will take only the other 2 changes? Or David will
> take all changes and we have to rebase?

I think the best way forwards is for me to take only the first two changes.

I don't think that this fix is 3.4 material and as you say we expect this
problem to be resolved by other means in 3.5.

I am of course open to discussion on this.
