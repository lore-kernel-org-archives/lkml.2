Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab1BIV26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:28:58 -0500
Received: from brother.balabit.com ([195.70.62.219]:42514 "EHLO
	lists.balabit.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab1BIV25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:28:57 -0500
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
From: Gergely Nagy <algernon@balabit.hu>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: david@lang.hm, James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20110209212329.GA24777@mail.hallyn.com>
References: <1296733177.14846.26.camel@moria>
	 <20110203153252.GA24153@mail.hallyn.com>
	 <20110204160513.GB17396@mail.hallyn.com> <1296837186.24742.15.camel@moria>
	 <20110204171502.GA24226@mail.hallyn.com>
	 <alpine.DEB.2.00.1102042301420.8162@asgard.lang.hm>
	 <20110206011831.GB15805@mail.hallyn.com>
	 <20110209212329.GA24777@mail.hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Organization: BalaBit
Date: Wed, 09 Feb 2011 22:28:54 +0100
Message-ID: <1297286934.13055.57.camel@luthien.mhp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 21:23 +0000, Serge E. Hallyn wrote: 
> So if that's how we're leaning, then the following patch is much more
> concise.  I'll send this to Linus and any appropriate -stable tomorrow
>  if noone objects.
> 
> From 5166e114d6a7c508addbadd763322089eb0b02f5 Mon Sep 17 00:00:00 2001
> From: Serge Hallyn <serge@hallyn.com>
> Date: Thu, 3 Feb 2011 09:26:15 -0600
> Subject: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now (v2)
> 
> It'd be nice to do that later, but it's not strictly necessary,
> and it'll be hard to do without breaking somebody's userspace.
> 
> Signed-off-by: Serge Hallyn <serge@hallyn.com>
> ---
>  kernel/printk.c |   14 ++++----------
>  1 files changed, 4 insertions(+), 10 deletions(-)

Personally, I'd prefer the sysctl idea in the long run, because
userspace can easily and automatically adapt to the running kernel then.
Ie, this patch is fine for 2.6.38, but later on, a sysctl could be
introduced, that when set (but defaulting to unset, as to not break
userspace), would make CAP_SYS_ADMIN return -EPERM. That way, syslogds
could look at the setting, and act accordingly. This would mean that old
userspace wouldn't break, and upgraded userspace could work on both old
and new kernels, depending on the setting. Distros or admins could then
enable the sysctl once they made sure that all neccessary applications
have been upgraded.

But this works too, for now. My immediate concern is making sure 2.6.38
doesn't break capability-using syslogds.

-- 
|8]



