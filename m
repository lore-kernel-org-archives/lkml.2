Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab0HEDP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 23:15:29 -0400
Received: from tundra.namei.org ([65.99.196.166]:41974 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958Ab0HEDP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 23:15:26 -0400
Date: Thu, 5 Aug 2010 13:15:16 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: John Johansen <john.johansen@canonical.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH -next] apparmor: depends on NET
In-Reply-To: <4C57825E.6020103@canonical.com>
Message-ID: <alpine.LRH.2.00.1008051313500.8765@tundra.namei.org>
References: <20100802144432.70293bda.sfr@canb.auug.org.au> <20100802105218.c2050fff.randy.dunlap@oracle.com> <4C57825E.6020103@canonical.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010, John Johansen wrote:

> On 08/02/2010 10:52 AM, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > SECURITY_APPARMOR should depend on NET since AUDIT needs
> > (depends on) NET.
> > 
> yes, thanks .that depends seems to have been dropped when I
> split out networking hooks for later submission
> 
> Signed-off-by: John Johansen <john.johansen@canonical.com>

Thanks, I'll fix these up in the next day or so now that the code is 
merged with Linus.


> 
> > Fixes 70-80 errors that occur when CONFIG_NET is not enabled,
> > but APPARMOR selects AUDIT without qualification.  E.g.:
> > 
> > audit.c:(.text+0x33361): undefined reference to `netlink_unicast'
> > (.text+0x333df): undefined reference to `netlink_unicast'
> > audit.c:(.text+0x3341d): undefined reference to `skb_queue_tail'
> > audit.c:(.text+0x33424): undefined reference to `kfree_skb'
> > audit.c:(.text+0x334cb): undefined reference to `kfree_skb'
> > audit.c:(.text+0x33597): undefined reference to `skb_put'
> > audit.c:(.text+0x3369b): undefined reference to `__alloc_skb'
> > audit.c:(.text+0x336d7): undefined reference to `kfree_skb'
> > (.text+0x3374c): undefined reference to `__alloc_skb'
> > auditfilter.c:(.text+0x35305): undefined reference to `skb_queue_tail'
> > lsm_audit.c:(.text+0x2873): undefined reference to `init_net'
> > lsm_audit.c:(.text+0x2878): undefined reference to `dev_get_by_index'
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Cc: John Johansen <john.johansen@canonical.com>
> > ---
> >  security/apparmor/Kconfig |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- linux-next-20100802.orig/security/apparmor/Kconfig
> > +++ linux-next-20100802/security/apparmor/Kconfig
> > @@ -1,6 +1,6 @@
> >  config SECURITY_APPARMOR
> >  	bool "AppArmor support"
> > -	depends on SECURITY
> > +	depends on SECURITY && NET
> >  	select AUDIT
> >  	select SECURITY_PATH
> >  	select SECURITYFS
> 

-- 
James Morris
<jmorris@namei.org>
