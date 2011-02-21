Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab1BUMJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 07:09:11 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55699 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab1BUMJJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 07:09:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qh0hNq6KGLSsbtNUAiDp2UkqsQDLhuN3+pz+zXSN/PXBHXqhXqLwA7JbDZ/oPfn7lR
         LGqZPLT0+zzwH5nbAQlJGUUWuU6aa5sKtQNH59mh7EYC9L7P2oSgePHuVQNQNg4nKIJa
         Z65YUeWIyu0ojuFgG5PHF5zk5o1HPgQANW5+4=
MIME-Version: 1.0
In-Reply-To: <20110221073640.GA3094@legolas.emea.dhcp.ti.com>
References: <1297068547-10635-1-git-send-email-weber@corscience.de>
	<4D5A6353.7040907@maxwell.research.nokia.com>
	<20110215113717.GN2570@legolas.emea.dhcp.ti.com>
	<4D5A672A.7040000@samsung.com>
	<4D5A6874.1080705@corscience.de>
	<20110215115349.GQ2570@legolas.emea.dhcp.ti.com>
	<4D5A6EEC.5000908@maxwell.research.nokia.com>
	<AANLkTik+6fguqgH8Bpnpqo7Axmquy3caRMELTZVmuN1j@mail.gmail.com>
	<20110219150024.GA4487@legolas.emea.dhcp.ti.com>
	<AANLkTik5dwNZrUxjgjKeAQOsp610d6y_TNGg1b5Vc5Zd@mail.gmail.com>
	<20110221073640.GA3094@legolas.emea.dhcp.ti.com>
Date: Mon, 21 Feb 2011 14:09:07 +0200
Message-ID: <AANLkTinf3Wj=nw_2Sx4r-VSsCH+=fzx-25hynH8hB0d9@mail.gmail.com>
Subject: Re: [PATCH resend] video: omap24xxcam: Fix compilation
From: David Cohen <dacohen@gmail.com>
To: balbi@ti.com
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
        Thomas Weber <weber@corscience.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-omap@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, Tejun Heo <tj@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 9:36 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Sat, Feb 19, 2011 at 06:04:58PM +0200, David Cohen wrote:
>> > I have to disagree. The fundamental problem is the circular dependency
>> > between those two files:
>> >
>> > sched.h uses wait_queue_head_t defined in wait.h
>> > wait.h uses TASK_* defined in sched.h
>> >
>> > So, IMO the real fix would be clear out the circular dependency. Maybe
>> > introducing <linux/task.h> to define those TASK_* symbols and include
>> > that on sched.h and wait.h
>> >
>> > Just dig a quick and dirty to try it out and works like a charm
>>
>> We have 2 problems:
>>  - omap24xxcam compilation broken
>>  - circular dependency between sched.h and wait.h
>>
>> To fix the broken compilation we can do what the rest of the kernel is
>> doing, which is to include sched.h.
>> Then, the circular dependency is fixed by some different approach
>> which would probably change *all* current usage of TASK_*.
>
> considering that 1 is caused by 2 I would fix 2.
>
>> IMO, there's no need to create a dependency between those issues.
>
> There's no dependency between them, it's just that the root cause for
> this problem is a circular dependency between wait.h and sched.h

I did a try to fix this circular dependency and the comment I got was
to include sched.h in omap24xxcam.c file:
http://marc.info/?l=linux-omap&m=129828637120270&w=2

I'm working to remove v4l2 internal device interface from omap24xxcam
and then I need this driver's compilation fixed.
The whole kernel is including sched.h when wake_up*() macro is used,
so this should be our first solution IMO.
As I said earlier, no need to make this compilation fix be dependent
of wait.h fix (if it's really going to be changed).

I think we should proceed with this patch.

Br,

David

>
> --
> balbi
>
