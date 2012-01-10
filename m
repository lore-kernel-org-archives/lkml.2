Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab2AJNFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 08:05:35 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:52436 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab2AJNFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 08:05:32 -0500
Message-ID: <4F0C375B.7040600@linux.vnet.ibm.com>
Date: Tue, 10 Jan 2012 18:34:27 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Kyungmin Park <kmpark@infradead.org>
CC: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: BUG: sleeping function called from invalid context at include/linux/freezer.h:45
References: <CAH9JG2XniMv5dVf1DixGNaQAJk-sZjnV9HfYeihEJP3JDyC4+Q@mail.gmail.com>
In-Reply-To: <CAH9JG2XniMv5dVf1DixGNaQAJk-sZjnV9HfYeihEJP3JDyC4+Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011013-8878-0000-0000-000000DDA04A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2012 09:57 AM, Kyungmin Park wrote:

> Dear all
> 
> with the latest kernel. I got the below bug message.
> It calls the sleep function. Does it intended operation?
> 
> static inline bool try_to_freeze(void)
> {
>         might_sleep();
>         if (likely(!freezing(current)))
>                 return false;
>         return __refrigerator(false);
> }
> 
> # poweroff
> [    6.852523] BUG: sleeping function called from invalid context at
> include/linux/freezer.h:45
> [    6.859489] in_atomic(): 0, irqs_disabled(): 128, pid: 1, name: init
> [    6.865846] [<c0013508>] (unwind_backtrace+0x0/0xec) from
> [<c0010124>] (do_signal+0x88/0x588)
> [    6.874337] [<c0010124>] (do_signal+0x88/0x588) from [<c001063c>]
> (do_notify_resume+0x18/0x38)
> [    6.882928] [<c001063c>] (do_notify_resume+0x18/0x38) from
> [<c000dc18>] (work_pending+0x24/0x28)
> 


You seem to be running on Arm architecture. Can you please try the patch
at https://lkml.org/lkml/2011/8/25/231 ?

Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

