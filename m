Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab2AKA5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 19:57:19 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54586 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab2AKA5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 19:57:18 -0500
MIME-Version: 1.0
In-Reply-To: <4F0C375B.7040600@linux.vnet.ibm.com>
References: <CAH9JG2XniMv5dVf1DixGNaQAJk-sZjnV9HfYeihEJP3JDyC4+Q@mail.gmail.com>
	<4F0C375B.7040600@linux.vnet.ibm.com>
Date: Wed, 11 Jan 2012 09:57:15 +0900
X-Google-Sender-Auth: UGzopOzFXUGWUTc56GGOUk24JtA
Message-ID: <CAH9JG2WQakNYM=CVbKmtSAB-09Vphh6xRVghrnXdiJu_Jrqetw@mail.gmail.com>
Subject: Re: BUG: sleeping function called from invalid context at include/linux/freezer.h:45
From: Kyungmin Park <kmpark@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/12, Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 01/10/2012 09:57 AM, Kyungmin Park wrote:
>
>> Dear all
>>
>> with the latest kernel. I got the below bug message.
>> It calls the sleep function. Does it intended operation?
>>
>> static inline bool try_to_freeze(void)
>> {
>>         might_sleep();
>>         if (likely(!freezing(current)))
>>                 return false;
>>         return __refrigerator(false);
>> }
>>
>> # poweroff
>> [    6.852523] BUG: sleeping function called from invalid context at
>> include/linux/freezer.h:45
>> [    6.859489] in_atomic(): 0, irqs_disabled(): 128, pid: 1, name: init
>> [    6.865846] [<c0013508>] (unwind_backtrace+0x0/0xec) from
>> [<c0010124>] (do_signal+0x88/0x588)
>> [    6.874337] [<c0010124>] (do_signal+0x88/0x588) from [<c001063c>]
>> (do_notify_resume+0x18/0x38)
>> [    6.882928] [<c001063c>] (do_notify_resume+0x18/0x38) from
>> [<c000dc18>] (work_pending+0x24/0x28)
>>
>
>
> You seem to be running on Arm architecture. Can you please try the patch
> at https://lkml.org/lkml/2011/8/25/231 ?

Thank you,
It's working and I read the all mails related with this issue. and
need to fix it at arm side.

I think some more codes from arm are needed to work it properly.

Thank you,
Kyungmin Park
>
> Regards,
> Srivatsa S. Bhat
> IBM Linux Technology Center
>
>
