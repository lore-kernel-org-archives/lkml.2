Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab2FKPg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:36:27 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:60175 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753478Ab2FKPgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:36:25 -0400
MIME-Version: 1.0
In-Reply-To: <41394741acbaf5451f81382a2f31b44f.squirrel@www.codeaurora.org>
References: <1339011882-7919-1-git-send-email-merez@codeaurora.org>
 <CANfBPZ8C7YY760yx9ATi1_UJ_itL0N+fVdxx0Lim-55SgGjbng@mail.gmail.com> <41394741acbaf5451f81382a2f31b44f.squirrel@www.codeaurora.org>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Mon, 11 Jun 2012 21:06:01 +0530
Message-ID: <CANfBPZ9U+b4p5UQbX_oeLba28fTMfUrVONN=bRakn6d2Or=1ew@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] block: Add test-iosched scheduler
To: merez@codeaurora.org
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 9, 2012 at 8:24 PM,  <merez@codeaurora.org> wrote:
>
>> On Thu, Jun 7, 2012 at 1:14 AM, Maya Erez <merez@codeaurora.org> wrote:
>>> The test scheduler allows testing a block device by dispatching
>>> specific requests according to the test case and declare PASS/FAIL
>>> according to the requests completion error code
>>>
>> I can't get the point. Isn't this possible purely from userspace using
>> IOCTLs ?
>> Even otherwise, requiring to modify the scheduler for each test case
>> is definitely not scalable.
> The main benefit of the test-iosched is the ability to determine the
> timing of each request that is being dispatched and to put on hold the
> real FS requests so that they won't affect the tests scenario.

Then a potentially long running test can block any useful work that can
be done on the device. no-op is not the right scheduler for the example
you mentioned (eMMC), so such device has to be mounted only for the
purpose of running the tests.
So using standard noop + debugfs would be sufficient for 99% of the cases ?

> It also allows each block device to determine pass/fail result taking into
> account the expected behavior and the actual result.


> The scheduler doesn't have to be changed per tests case. What made you
> think it should be?
Err.. I misread this section of documentation. I read is as sysfs
instead of debugfs.
My mistake..
<Quote>
+Each test is exposed via debugfs and can be triggered by writing to
+the debugfs file. In order to add a new test one should expose a new debugfs
+file for the new test.
</Quote>

> Currently we use the test-iosched to test the eMMC4.5 features (such as
> BKOPs, packed commands and sanitize). I hope that after we will release
> the tests later this week it will be clearer.
>>
Sure. It'd be useful.
