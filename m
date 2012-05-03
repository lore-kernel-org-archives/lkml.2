Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab2ECSqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:46:52 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40005 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758000Ab2ECSqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:46:49 -0400
Message-ID: <4FA2D21D.6010805@linaro.org>
Date: Thu, 03 May 2012 11:44:45 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 0/5] Rationalize time keeping
References: <cover.1335510125.git.richardcochran@gmail.com> <4F9B228F.90903@linaro.org> <20120503182128.GB2254@netboy.at.omicron.at>
In-Reply-To: <20120503182128.GB2254@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050318-9360-0000-0000-000005FE7397
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 11:21 AM, Richard Cochran wrote:
> On Fri, Apr 27, 2012 at 03:49:51PM -0700, John Stultz wrote:
>> On 04/27/2012 01:12 AM, Richard Cochran wrote:
>>> * Performance Impacts
>>> ** con
>>>     - Small extra cost when reading the time (one integer addition plus
>>>       one integer test).
>> This may not be so small when it comes to folks who are very
>> concerned about the clock_gettime hotpath.
>> Further, the correction will be needed to be made in the vsyscall
>> paths, which isn't done with your current patchset (causing userland
>           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> to see different time values then what kernel space calculates).
> John, now that you clarified the vDSO thing, I am very confused about
> this statement of yours. It appears that the vDSO data are updated
> when timekeeping_update() in timekeeper.c calls update_vsyscall().
>
> I think the hunk from patch #5, below, does in fact adjust the time
> value correctly before it gets handed off to the arch-specific
> update_vsyscall() to be copied into the vDSO page. So I'll make the
> claim that:
>
> 1. We don't have to touch the vsyscall paths for this.
> 2. This change does not affect vDSO performance at all.
>
But the changes you make to getnstimeofday() still needs to happen in 
the vDSO code. The vDSO code basically implements getnstimeofday() in 
userland.

If you're code is trying to make it so that the leap-second is properly 
handled at the second boundary instead of the tick boundary, there must 
me some change needed to the vDSO, since the vDSO code is updated only 
each tick. Otherwise how can you enforce the leap after the second 
boundary but before the tick?

thanks
-john

