Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab1BDAtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 19:49:16 -0500
Received: from mail.lang.hm ([64.81.33.126]:57585 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab1BDAtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 19:49:15 -0500
Date: Thu, 3 Feb 2011 16:49:08 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Serge E. Hallyn" <serge@hallyn.com>
cc: Gergely Nagy <algernon@balabit.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
In-Reply-To: <20110203165132.GA28172@mail.hallyn.com>
Message-ID: <alpine.DEB.2.00.1102031647150.30983@asgard.lang.hm>
References: <1296733177.14846.26.camel@moria> <20110203153252.GA24153@mail.hallyn.com> <1296748401.14846.39.camel@moria> <20110203165132.GA28172@mail.hallyn.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011, Serge E. Hallyn wrote:

> Quoting Gergely Nagy (algernon@balabit.hu):
>> On Thu, 2011-02-03 at 15:32 +0000, Serge E. Hallyn wrote:
>>>> Back in november, a patch was merged into the kernel (in  commit
>>>> ce6ada35bdf710d16582cc4869c26722547e6f11), that splits CAP_SYSLOG out of
>>>> CAP_SYS_ADMIN.
>>>>
>>>> Sadly, this has an unwelcomed consequence, that any userspace syslogd
>>>> that formerly used CAP_SYS_ADMIN will stop working, unless upgraded, or
>>>> otherwise adapted to the change.
>>>>
>>>> However, updating userspace isn't that easy, either, if one wants to
>>>> support multiple kernels with the same userspace binary: pre-2.6.38, one
>>>> needs CAP_SYS_ADMIN, but later kernels will need CAP_SYS_ADMIN. It would
>>>> be trivial to keep both, but that kind of defeats the purpose of
>>>> CAP_SYSLOG,
>>>
>>> The idea would be to only use both when you detect a possibly older
>>> kernel.
>>
>> I was considering that, but... how do I reliably detect an older kernel?
>> So far, I didn't find a reliable way with which I can detect a kernel
>> version at run-time (apart from parsing utsname)
>
> ...  Why not parse utsname?

because the name may be different on different systems, a generic software 
package is not going to be able to interpret them all.

>>> However, you're right of course, I really should have provided some way
>>> for userspace to click 'ok, got the message, now continue anyway because
>>> I'm running older userspace for now,'  i.e. a sysctl perhaps.
>>>
>>> Sorry about the trouble.  Here is a patch to just warn for now, with
>>> the changelog showing what i intend to push next.
>>>
>>> sorry again,
>>> -serge
>>>
>>> From 2d7408541dd3a6e19a4265b028233789be6a40f4 Mon Sep 17 00:00:00 2001
>>> From: Serge Hallyn <serge@peq.(none)>
>>> Date: Thu, 3 Feb 2011 09:26:15 -0600
>>> Subject: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now
>>>
>>> At 2.6.39 or 2.6.40, let's add a sysctl which defaults to 0.  When
>>> 0, refuse if cap_sys_admin, if 1, then allow.  This will allow
>>> users to acknowledge (permanently, if they must, using /etc/sysctl.conf)
>>> that they've seen the syslog message about cap_sys_admin being
>>> deprecated for syslog.
>>
>> Could we have it the other way around, at least for a while? Otherwise,
>
> Sure.
>
> So long as there is a definite path toward eventually having syslog
> with CAP_SYS_ADMIN be denied.

I can see what you would want to allow for a syslog daemon to have 
CAP_SYSLOG without needing to have CAP_SYS_ADMIN, but why do you see it as 
important to deny the ability if someone has CAP_SYS_ADMIN?

David Lang

