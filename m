Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab1BIVrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:47:08 -0500
Received: from mail.lang.hm ([64.81.33.126]:37386 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab1BIVrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:47:06 -0500
Date: Wed, 9 Feb 2011 13:47:01 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Gergely Nagy <algernon@balabit.hu>
cc: "Serge E. Hallyn" <serge@hallyn.com>, James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
In-Reply-To: <1297287604.13055.65.camel@luthien.mhp>
Message-ID: <alpine.DEB.2.00.1102091344410.1472@asgard.lang.hm>
References: <1296733177.14846.26.camel@moria>  <20110203153252.GA24153@mail.hallyn.com>  <20110204160513.GB17396@mail.hallyn.com> <1296837186.24742.15.camel@moria>  <20110204171502.GA24226@mail.hallyn.com>  <alpine.DEB.2.00.1102042301420.8162@asgard.lang.hm>
  <20110206011831.GB15805@mail.hallyn.com>  <20110209212329.GA24777@mail.hallyn.com>  <1297286934.13055.57.camel@luthien.mhp>  <alpine.DEB.2.00.1102091333370.1472@asgard.lang.hm> <1297287604.13055.65.camel@luthien.mhp>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011, Gergely Nagy wrote:

> On Wed, 2011-02-09 at 13:34 -0800, david@lang.hm wrote:
>> On Wed, 9 Feb 2011, Gergely Nagy wrote:
>>
>>> On Wed, 2011-02-09 at 21:23 +0000, Serge E. Hallyn wrote:
>>>> So if that's how we're leaning, then the following patch is much more
>>>> concise.  I'll send this to Linus and any appropriate -stable tomorrow
>>>>  if noone objects.
>>>>
>>>> From 5166e114d6a7c508addbadd763322089eb0b02f5 Mon Sep 17 00:00:00 2001
>>>> From: Serge Hallyn <serge@hallyn.com>
>>>> Date: Thu, 3 Feb 2011 09:26:15 -0600
>>>> Subject: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now (v2)
>>>>
>>>> It'd be nice to do that later, but it's not strictly necessary,
>>>> and it'll be hard to do without breaking somebody's userspace.
>>>>
>>>> Signed-off-by: Serge Hallyn <serge@hallyn.com>
>>>> ---
>>>>  kernel/printk.c |   14 ++++----------
>>>>  1 files changed, 4 insertions(+), 10 deletions(-)
>>>
>>> Personally, I'd prefer the sysctl idea in the long run, because
>>> userspace can easily and automatically adapt to the running kernel then.
>>> Ie, this patch is fine for 2.6.38, but later on, a sysctl could be
>>> introduced, that when set (but defaulting to unset, as to not break
>>> userspace), would make CAP_SYS_ADMIN return -EPERM. That way, syslogds
>>> could look at the setting, and act accordingly. This would mean that old
>>> userspace wouldn't break, and upgraded userspace could work on both old
>>> and new kernels, depending on the setting. Distros or admins could then
>>> enable the sysctl once they made sure that all neccessary applications
>>> have been upgraded.
>>
>> what is your justification for ever having CAP_SYS_ADMIN return -EPERM?
>> what's the value in blocking this.
>
> Nothing. Come to think of it, the main use of the sysctl would be to
> detect CAP_SYSLOG support, so that applications can drop CAP_SYS_ADMIN
> and use CAP_SYSLOG only (which, imo, is a good idea - the less
> capabilities, the better, and CAP_SYS_ADMIN is quite broad when one only
> wants CAP_SYSLOG).
>
> If there's a better way to allow userspace to easily detect CAP_SYSLOG,
> I'm all for that.

if userspace wants to detect this, what is wrong with them checking for a 
kernel >= 2.6.38?

realistically, if the upstream applications (which need to work with many 
different versions) just support having CAP_SYS_ADMIN, it would be a very 
minor distro patch to change this to CAP_SYSLOG for a distro release where 
the distro _knows_ that they don't have to support an older kernel.

David Lang
