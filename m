Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab2FIOyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 10:54:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49860 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2FIOyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 10:54:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6736"; a="197125610"
Message-ID: <41394741acbaf5451f81382a2f31b44f.squirrel@www.codeaurora.org>
In-Reply-To: <CANfBPZ8C7YY760yx9ATi1_UJ_itL0N+fVdxx0Lim-55SgGjbng@mail.gmail.com>
References: <1339011882-7919-1-git-send-email-merez@codeaurora.org>
    <CANfBPZ8C7YY760yx9ATi1_UJ_itL0N+fVdxx0Lim-55SgGjbng@mail.gmail.com>
Date: Sat, 9 Jun 2012 07:54:18 -0700 (PDT)
Subject: Re: [PATCH v2 0/1] block: Add test-iosched scheduler
From: merez@codeaurora.org
To: "S, Venkatraman" <svenkatr@ti.com>
Cc: "Maya Erez" <merez@codeaurora.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Thu, Jun 7, 2012 at 1:14 AM, Maya Erez <merez@codeaurora.org> wrote:
>> The test scheduler allows testing a block device by dispatching
>> specific requests according to the test case and declare PASS/FAIL
>> according to the requests completion error code
>>
> I can't get the point. Isn't this possible purely from userspace using
> IOCTLs ?
> Even otherwise, requiring to modify the scheduler for each test case
> is definitely not scalable.
The main benefit of the test-iosched is the ability to determine the
timing of each request that is being dispatched and to put on hold the
real FS requests so that they won't affect the tests scenario.
It also allows each block device to determine pass/fail result taking into
account the expected behavior and the actual result.
The scheduler doesn't have to be changed per tests case. What made you
think it should be?
Currently we use the test-iosched to test the eMMC4.5 features (such as
BKOPs, packed commands and sanitize). I hope that after we will release
the tests later this week it will be clearer.
>
>> Changes in v2:
>>    - Export test-iosched functionality to allow definition of the block
>> device
>>      tests under the block device layer
>>    - Add registration of block device tests utilities
>>
>> Maya Erez (1):
>>  block: Add test-iosched scheduler
>>
>>  Documentation/block/test-iosched.txt |   39 ++
>>  block/Kconfig.iosched                |    8 +
>>  block/Makefile                       |    1 +
>>  block/blk-core.c                     |    3 +-
>>  block/test-iosched.c                 | 1025
>> ++++++++++++++++++++++++++++++++++
>>  include/linux/test-iosched.h         |  218 +++++++
>>  6 files changed, 1292 insertions(+), 2 deletions(-)
>>  create mode 100644 Documentation/block/test-iosched.txt
>>  create mode 100644 block/test-iosched.c
>>  create mode 100644 include/linux/test-iosched.h
>>
>

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

