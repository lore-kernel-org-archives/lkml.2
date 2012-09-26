Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab2IZSOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:14:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40248 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab2IZSOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:14:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6847"; a="239218684"
Message-ID: <506345FD.8010609@codeaurora.org>
Date: Wed, 26 Sep 2012 11:14:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pankaj Jangra <jangra.pankaj9@gmail.com>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 08/10] ARM: msm: Prepare clk_get() users in mach-msm for
 clock-pcom driver
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org> <1348194419-11486-9-git-send-email-sboyd@codeaurora.org> <CADTbHxrQQ9GQKm1Xd3gn4eLu=uKvkdHRvBYDq0iRLiJwy+1amw@mail.gmail.com>
In-Reply-To: <CADTbHxrQQ9GQKm1Xd3gn4eLu=uKvkdHRvBYDq0iRLiJwy+1amw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/12 10:35, Pankaj Jangra wrote:
> Hi,
>
> On Fri, Sep 21, 2012 at 7:56 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> In the near future we'll be moving clock-pcom to a platform
>> driver, in which case these two users of clk_get() in mach-msm
>> need to be updated. Have board-trout-panel.c make the proc_comm
>> call directly so that we don't have to port this board specific
>> code to the driver right now and reorder the initcall order of
>> dma.c so that it initializes after the clock driver probes but
>> before any drivers use dma APIs.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  arch/arm/mach-msm/Makefile            |  9 ++++++---
>>  arch/arm/mach-msm/board-trout-panel.c | 19 +++++++------------
>>  arch/arm/mach-msm/dma.c               |  5 ++---
>>  3 files changed, 15 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
>> index 17519fa..3dbae74 100644
>> --- a/arch/arm/mach-msm/Makefile
>> +++ b/arch/arm/mach-msm/Makefile
>> @@ -5,12 +5,15 @@ obj-$(CONFIG_DEBUG_FS) += clock-debug.o
>>  obj-$(CONFIG_MSM_VIC) += irq-vic.o
>>  obj-$(CONFIG_MSM_IOMMU) += devices-iommu.o
>>
>> -obj-$(CONFIG_ARCH_MSM7X00A) += dma.o irq.o
>> -obj-$(CONFIG_ARCH_MSM7X30) += dma.o
>> -obj-$(CONFIG_ARCH_QSD8X50) += dma.o sirc.o
>> +obj-$(CONFIG_ARCH_MSM7X00A) += irq.o
>> +obj-$(CONFIG_ARCH_QSD8X50) += sirc.o
>>
>>  obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
>>
>> +obj-$(CONFIG_ARCH_MSM7X00A) += dma.o
>> +obj-$(CONFIG_ARCH_MSM7X30) += dma.o
>> +obj-$(CONFIG_ARCH_QSD8X50) += dma.o
>> +
> I did not understand what is the need of this change in Makefile?

Quoted from commit text:

reorder the initcall order of
dma.c so that it initializes after the clock driver probes but
before any drivers use dma APIs.


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

