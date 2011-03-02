Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab1CBUSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:18:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48563 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab1CBUSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:18:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J6Q/gm3fZYN/sHgzUbTunPyNf0snJQ6SInPNbDRU2RJ2F5KhhDG/MGgo+JjJ9E59JG
         OBqQBGg3aemPdRXlEMw4Z9eWK6sQwlbgDzzVzT5419xpr4BcAIKVTz/EgD4cYswoNeDi
         2uo1i/AtEKlkJ+Zkbfc807FGXSNiAGpF+l8NE=
Date: Wed, 2 Mar 2011 23:18:07 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Jake Edge <jake@lwn.net>
Cc: linux-kernel@vger.kernel.org, mjt@tls.msk.ru, arnd@arndb.de,
        mirqus@gmail.com, netdev@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, eric.dumazet@gmail.com, therbert@google.com,
        xiaosuo@gmail.com, jesse@nicira.com, kees.cook@canonical.com,
        eugene@redhat.com, dan.j.rosenberg@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] net: don't allow CAP_NET_ADMIN to load non-netdev
 kernel modules
Message-ID: <20110302201807.GA31965@albatros>
References: <201102272122.52643.arnd@arndb.de>
 <4D6B6AE7.2050202@msgid.tls.msk.ru>
 <20110228095133.GA4351@albatros>
 <20110228.112349.104067277.davem@davemloft.net>
 <20110301194845.GA3533@albatros>
 <1299010390.2529.30.camel@bwh-desktop>
 <20110301213313.GA6507@albatros>
 <m34o7ltipi.fsf@lwn.net>
 <20110302194354.GA31043@albatros>
 <20110302124936.289a1915@chukar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302124936.289a1915@chukar>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 12:49 -0700, Jake Edge wrote:
> On Wed, 2 Mar 2011 22:43:54 +0300 Vasiliy Kulikov wrote:
> > On Wed, Mar 02, 2011 at 12:39 -0700, Jake Edge wrote:
> > > > @@ -1765,4 +1765,4 @@ module_exit(ipgre_fini);
> > > >  MODULE_LICENSE("GPL");
> > > >  MODULE_ALIAS_RTNL_LINK("gre");
> > > >  MODULE_ALIAS_RTNL_LINK("gretap");
> > > > -MODULE_ALIAS("gre0");
> > > > +MODULE_ALIAS_NETDEV("gre0");
> > > 
> > > that is, instead of replacing MODULE_ALIAS("gre0") with the NETDEV
> > > version, don't you want both for backward compatibility?
> > 
> > The networking script will run with CAP_NET_ADMIN, this would request
> > netdev-gre0 and load ip_gre.
> 
> and on systems that today use CAP_SYS_MODULE

Since Linux 2.6.32 CAP_SYS_MODULE may not load modules via "ifconfig
gre0".  It was changed to CAP_NET_ADMIN.  So nothing is broken here.

> (or really the full set of
> capabilities cuz they are running as root)?

As root has CAP_NET_ADMIN, the alias netdev-gre0 is tried and it succeeds.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
