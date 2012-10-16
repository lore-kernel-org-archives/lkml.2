Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab2JPLcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:32:32 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46739 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2JPLca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:32:30 -0400
MIME-Version: 1.0
In-Reply-To: <CABb+yY2a_QEPvrT6yPBz1gM_avBTH2GRRD3bUKk+mCCMGgcfuQ@mail.gmail.com>
References: <1349432276-22919-1-git-send-email-inderpal.singh@linaro.org>
	<CABb+yY2a_QEPvrT6yPBz1gM_avBTH2GRRD3bUKk+mCCMGgcfuQ@mail.gmail.com>
Date: Tue, 16 Oct 2012 17:02:28 +0530
Message-ID: <CAG17yqR_ZqRULT209N0PvhuwWfUYdA1sj6pb2sMq_4F-2Po-Pw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] DMA: PL330: Fix mem leaks and balance probe/remove
From: Inderpal Singh <inderpal.singh@linaro.org>
To: vinod.koul@intel.com, Jassi Brar <jassisinghbrar@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        boojin.kim@samsung.com, patches@linaro.org, kgene.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 October 2012 16:33, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> On Fri, Oct 5, 2012 at 3:47 PM, Inderpal Singh
> <inderpal.singh@linaro.org> wrote:
>> The first 2 patches of this series fix memory leaks because the memory
>> allocated for peripheral channels and DMA descriptors were not getting
>> freed.
>>
>> The last 2 patches balance the module's remove function.
>>
>> This series depends on "61c6e7531d3b66b3 ........DMA: PL330: Check the
>> pointer returned by kzalloc" which is on slave-dma's "fixes" branch.
>> Hence slave-dma tree's "next" branch was merged with "fixes" and
>> applied patch at [1] to fix the build error.
>>
>> [1] http://permalink.gmane.org/gmane.linux.kernel.next/24274
>>
>> Changes since v1:
>>  - Protect only list_add_tail with spin_locks
>>  - Return EBUSY from remove if channel is in use
>>  - unregister dma_device in remove
>>
>> Inderpal Singh (4):
>>   DMA: PL330: Free memory allocated for peripheral channels
>>   DMA: PL330: Change allocation method to properly free  DMA
>>     descriptors
>>   DMA: PL330: Balance module remove function with probe
>>   DMA: PL330: unregister dma_device in module's remove function
>>
>>  drivers/dma/pl330.c |   53 ++++++++++++++++++++++++++++++++++++---------------
>>  1 file changed, 38 insertions(+), 15 deletions(-)
>>
> All seem fine.
> Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
>
Thanks Jassi.

Vinod,
I have tested this series against your latest slave-dma ->fixes branch
which is based on 3.7-rc1.
The patchset applies cleanly and works fine.

Thanks,
Inder

> Thanks.
