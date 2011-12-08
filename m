Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab1LHNct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 08:32:49 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48492 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1LHNcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 08:32:46 -0500
MIME-Version: 1.0
In-Reply-To: <1323332205.1641.29.camel@vkoul-udesk3>
References: <1323168355-2764-1-git-send-email-tushar.behera@linaro.org>
	<1323168355-2764-2-git-send-email-tushar.behera@linaro.org>
	<1323329702.1641.26.camel@vkoul-udesk3>
	<002201ccb57d$056d2440$10476cc0$%kim@samsung.com>
	<1323332205.1641.29.camel@vkoul-udesk3>
Date: Thu, 8 Dec 2011 19:02:45 +0530
Message-ID: <CAJe_Zhf5-x0+9nrjCyY1N60jyxYm1qoF3Agg0jb7Te-dP8z5gw@mail.gmail.com>
Subject: Re: [PATCH 1/2] DMA: PL330: Remove pm_runtime_xxx calls from pl330 probe/remove
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linaro-dev@lists.linaro.org, Boojin Kim <boojin.kim@samsung.com>,
        patches@linaro.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 December 2011 13:46, Vinod Koul <vinod.koul@intel.com> wrote:
> On Thu, 2011-12-08 at 16:43 +0900, Kukjin Kim wrote:
>> Vinod Koul wrote:
>> >
>> > On Tue, 2011-12-06 at 16:15 +0530, Tushar Behera wrote:
>> > > amba_probe() now calls pm_runtime_get_noresume() and pm_runtime_enable()
>> > > for the devices before the device probe is called. Hence we don't need
>> > > to call pm_runtime_get_xxx and pm_runtime_enable() in device probe again.
>> > > In the same way, since amba_remove() calls the respective pm_runtime
>> > > functions, those functions need not be called from device remove.
>> > >
>> > > This patch fixes following run time error with pl330 driver.
>> > >
>> > > dma-pl330 dma-pl330.0: Unbalanced pm_runtime_enable!
>> > > dma-pl330 dma-pl330.0: failed to get runtime pm
>> > >
>> > > Signed-off-by: Giridhar Maruthy <giridhar.maruthy@linaro.org>
>> > > Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> > Looks fine to me. Do you want these to go thru slave-dma or samsung
>> > tree.
>>
>> Hi Vinod,
>>
>> I think, this patch can be sent to upstream via slave-dma tree and
>> second one via Samsung tree separately and you can add my and Boojin
>> Kim's ack(actually, she replied) on this when you apply.
>
> Okay, I have applied this one only
>
Guys, any reason to keep me, the author of the driver, out of loop ?
I almost lost this patch, had it not for chance.

Also, I noticed
42bc9cf45939c2   'DMA: PL330: Add DMA_CYCLIC capability'
while implements my correction, doesn't carry the ack
 http://www.spinics.net/lists/linux-samsung-soc/msg06386.html

While, unlike some, I am not interested in claiming territory by pissing
around acks, I would sure like to log my acks if I spent personal time
maintaining the code I am supposed to be responsible for.
