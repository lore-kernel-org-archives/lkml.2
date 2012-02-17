Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab2BQB5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:57:46 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:47189 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865Ab2BQB5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:57:44 -0500
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Feb 2012 20:57:40 -0500
From: Eric B Munson <emunson@mgebm.net>
To: john stultz <johnstul@us.ibm.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: soft lockup detector & virtualisation
In-Reply-To: <CANcMJZAfT7Sz=5D=PVQwoy_hvEYZxowUxBo4EXN-U72mecE9SQ@mail.gmail.com>
References: <20120216231533.GA7392@redhat.com>
 <CANcMJZAfT7Sz=5D=PVQwoy_hvEYZxowUxBo4EXN-U72mecE9SQ@mail.gmail.com>
Message-ID: <78aa6599cf8dddc4d44f39bcdd0bb917@mgebm.net>
User-Agent: Roundcube Webmail/0.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012 17:39:38 -0800, john stultz wrote:
> On Thu, Feb 16, 2012 at 3:15 PM, Dave Jones <davej@redhat.com> wrote:
>> Lately I've noticed quite a few soft lockup bugs being reported.
>> In many of them, they're coming from inside virtual guests.
>>
>> Is the softlockup detector fundamentally broken in this situation ?
>>
>> If the host doesn't schedule the guest for whatever reason,
>> or the user suspends the VM and resumes it later ?
>>
>> Here's the most recent example:
>> https://bugzilla.redhat.com/attachment.cgi?id=563767
>>
>> In many of these, the code where it's "stuck" isn't anything
>> special, which is why I think the guest just hasn't had a
>> timeslice in 185 seconds.
>>
>> Is there some way we can perhaps detect we're running virtualised,
>> and disable the detector automatically ?
>
> I think Eric's work (See "Add check for suspended vm in softlockup
> detector" sent out today) tries to address this issue.
>
> thanks
> -john


The work I have been doing specifically handles the case where the 
hypervisor suspends the guest.  There is talk of extending that work to 
handle preemption as well, which I think will cover your use case.

Eric
