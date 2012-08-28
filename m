Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab2H1GhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 02:37:06 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26707 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2H1GgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 02:36:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6817"; a="227855289"
Message-ID: <67c5a8179e7b9f9d6e41a10b1f1601a8.squirrel@www.codeaurora.org>
In-Reply-To: <340c1ff468880f247cc9377705edd6e4.squirrel@www.codeaurora.org>
References: <n> <1343744710-31700-2-git-send-email-merez@codeaurora.org>
    <09c3a301ad7ca4fa396c4d00615312c1.squirrel@www.codeaurora.org>
    <5017FDCE.5030700@kernel.dk>
    <340c1ff468880f247cc9377705edd6e4.squirrel@www.codeaurora.org>
Date: Mon, 27 Aug 2012 23:36:19 -0700 (PDT)
Subject: Re: [PATCH v5 1/3] block: Add test-iosched scheduler
From: merez@codeaurora.org
To: merez@codeaurora.org
Cc: "Jens Axboe" <axboe@kernel.dk>, merez@codeaurora.org,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Can you refer to my reply?
Currently the test-iosched is our only option for testing the eMMC4.5
features on a HS200 eMMC card.

Thanks,
Maya
On Thu, August 2, 2012 6:16 am, merez@codeaurora.org wrote:
>
> On Tue, July 31, 2012 8:46 am, Jens Axboe wrote:
>> On 07/31/2012 04:36 PM, merez@codeaurora.org wrote:
>>> Hi Jens,
>>>
>>> Do you have comments on this patch?
>>> Can we push it to kernel 3.6 version?
>>
>> I have questions - what is this good for? In other words, explain to me
>> why this is useful code. And in particular why this cannot be done from
>> userspace with bsg and block tracing?
>>
>> IOW, I'm dubious as to whether a new _io scheduler_ is the correct
>> solution to the problem you have at hand.
>>
>> --
>> Jens Axboe
>>
>>
>
> The test scheduler allows us to control the dispatched requests and their
> order without an interfering of other requests.
> You can review the patches which depends on this patch in order to better
> understand how it is used.
> For example, in the eMMC4.5 packed commands feature, the MMC layer can
> pack read or write requests (the packed requests must be of the same
> direction). MMC layer will stop fetching the requests in case the packing
> conditions are broken.
> In order to test this feature we had to have a full control on the
> requests that the MMC layer fetches and their order, so that we will be
> able to determine if the expected behavior was actually achieved.
> The test-iosched can call specific block device callbacks, for example for
> checking the test results.
> Also, in order to be able to run out tests on the main eMMC card that runs
> in HS200, we cannot "shut down" the real FS requests, otherwise our phone
> won't come up or crash.
> The test-iosched allows us to delay the real FS requests until the end of
> the test, therefore the tests can be done on the main eMMC card.
>
> We chose not to use blocktrace due to the "real" FS requests interference
> in the middle of the test.
>
> I'm not familiar with bsg so I cannot tell if it can answer all the
> requirements I specified above.
>
> Thanks,
> Maya
>
> --
> Sent by consultant of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
>
>


-- 
Sent by consultant of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

