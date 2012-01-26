Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab2AZQIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:08:11 -0500
Received: from mga10.intel.com ([192.55.52.92]:24369 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752666Ab2AZQIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:08:09 -0500
MIME-Version: 1.0
In-Reply-To: <4F21780F.7060504@atmel.com>
References: <1327592025-2461-1-git-send-email-danny.kukawka@bisect.de>
	<4F21780F.7060504@atmel.com>
Date: Thu, 26 Jan 2012 08:07:55 -0800
Message-ID: <CABE8wwsgNWFexoeVCTCP_MwJwhnOtG2YU+6FMLhnP+uq+QBR7g@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: dmatest: fix thread_count
From: Dan Williams <dan.j.williams@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Danny Kukawka <danny.kukawka@bisect.de>, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 7:58 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> On 01/26/2012 04:33 PM, Danny Kukawka :
>> It seems with commit f1aef8b6e6abf32a3a269542f95a19e2cb319f6c
>> another case where thread_count wasn't calculated correctly
>> has been overlooked.
>>
>> This fix also a -Wparentheses compiler warning.
>>
>> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>
>> ---
>>  drivers/dma/dmatest.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
>> index 2b8661b..24225f0 100644
>> --- a/drivers/dma/dmatest.c
>> +++ b/drivers/dma/dmatest.c
>> @@ -599,7 +599,7 @@ static int dmatest_add_channel(struct dma_chan *chan)
>>       }
>>       if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
>>               cnt = dmatest_add_threads(dtc, DMA_PQ);
>> -             thread_count += cnt > 0 ?: 0;
>> +             thread_count += cnt > 0 ? cnt : 0;
>>       }
>>
>>       pr_info("dmatest: Started %u threads using %s\n",

Thanks,

Already queued up, but maybe I'll append another Reported-by before
sending it up.

http://git.kernel.org/?p=linux/kernel/git/djbw/dmaengine.git;a=commitdiff;h=d07a74a546981a09ba490936645fbf0d1340b96c

--
Dan
