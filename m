Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab1CXV6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:58:51 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46620 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab1CXV6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:58:48 -0400
Date: Thu, 24 Mar 2011 16:57:47 -0500
From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
To: David Miller <davem@davemloft.net>
Cc: shemminger@vyatta.com, serge.hallyn@ubuntu.com, bhutchings@solarflare.com,
        eparis@redhat.com, eparis@parisplace.org, segoon@openwall.com,
        linux-kernel@vger.kernel.org, mjt@tls.msk.ru, arnd@arndb.de,
        mirqus@gmail.com, netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, eric.dumazet@gmail.com, therbert@google.com,
        xiaosuo@gmail.com, jesse@nicira.com, kees.cook@canonical.com,
        eugene@redhat.com, dan.j.rosenberg@gmail.com,
        akpm@linux-foundation.org, greg@kroah.com, sds@tycho.nsa.gov,
        linux-security-module@vger.kernel.org, dwalsh@redhat.com,
        dhowells@redhat.com
Subject: Re: [PATCH v2] net: don't allow CAP_NET_ADMIN to load non-netdev
 kernel modules
Message-ID: <20110324215747.GA12585@peq.hallyn.com>
References: <1300991584.2689.35.camel@bwh-desktop>
 <20110324202634.GB9191@peq.hallyn.com>
 <20110324143944.29f4c362@nehalam>
 <20110324.144628.58411809.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20110324.144628.58411809.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Miller (davem@davemloft.net):
> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Thu, 24 Mar 2011 14:39:44 -0700
> 
> > This breaks for many of the tunneling protocols, that rely on
> > autoload for names like "sit0"
> 
> Frankly I'm very disappointed in the fallout this has been causing.
> 
> Everyone supporting this change, get real, and admit it doing in fact
> cause a serious regression.

Sorry, I thought this was causing some extra audit messages but no
actual breakage?

> If you can't get past that simple fact, you cannot discuss this issue
> intelligently.
> 
> You can't say "userland will fix things up"
> 
> Because we're never supposed to break userland in the first place.
> 
> There is simply no excuse for this and I want this change reverted
> both in Linus's tree and in -stable.

Eric, in this particular case, since we've already done a
'capable(CAP_NET_ADMIN)', I woudl argue that doing the check
for CAP_SYS_ADMIN without auditing failure (even if it requires
a new helper in capability.c) isn't horrible.  Thoughts?

-serge
