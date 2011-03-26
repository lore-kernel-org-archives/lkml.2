Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab1CZKfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 06:35:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41057 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab1CZKfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 06:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d6Aaion+8AWlELZsO9XC3mljZopr5Z6x11T46xrUA0Abh0pK6RNtWYgNkVJBNL1TSY
         +r6hOeosPEeYBCZ/d1UWzq2BOmAYT2sijWAepg6pCcLlx4B2TORKDtTpGSe8ZS403ozi
         49jXhr9z498XNY/g8a0xynSUUEn0aFbqtdohc=
Date: Sat, 26 Mar 2011 13:35:39 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: David Miller <davem@davemloft.net>
Cc: shemminger@vyatta.com, serge.hallyn@ubuntu.com, bhutchings@solarflare.com,
        eparis@redhat.com, eparis@parisplace.org, linux-kernel@vger.kernel.org,
        mjt@tls.msk.ru, arnd@arndb.de, mirqus@gmail.com,
        netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        eric.dumazet@gmail.com, therbert@google.com, xiaosuo@gmail.com,
        jesse@nicira.com, kees.cook@canonical.com, eugene@redhat.com,
        dan.j.rosenberg@gmail.com, akpm@linux-foundation.org, greg@kroah.com,
        sds@tycho.nsa.gov, linux-security-module@vger.kernel.org,
        dwalsh@redhat.com, dhowells@redhat.com
Subject: Re: [PATCH v2] net: don't allow CAP_NET_ADMIN to load non-netdev
 kernel modules
Message-ID: <20110326103539.GA4719@albatros>
References: <1300991584.2689.35.camel@bwh-desktop>
 <20110324202634.GB9191@peq.hallyn.com>
 <20110324143944.29f4c362@nehalam>
 <20110324.144628.58411809.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324.144628.58411809.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 14:46 -0700, David Miller wrote:
> You can't say "userland will fix things up"
> 
> Because we're never supposed to break userland in the first place.

I admit that the patch breaks things.

But the thing is that kernel changes _are_ breaking userspace here and
there, not only by such obvious policy changes, but by indirect changes.
Note that the patch that changed CAP_SYS_MODULE to CAP_NET_ADMIN has
broken userspace behavior too - one could load modules with
CAP_SYS_MODULE without CAP_NET_ADMIN via "ifconfig wifi0" and after the
patch it could not.

Look at this patch:
http://patchwork.ozlabs.org/patch/42148/

It breaks userspace tools too - one might run LSM in learning mode to
create a profile for netfilter configuring, saw it didn't need any CAP_*
and totally denied them in the profile.  After many years (the bug was
fixed after 5+ years!) of good work it was broken by the patch.  The same
with plenty of patches that introduce different checks in places where
there were no permission checks at all or these checks were broken.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
