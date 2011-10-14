Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab1JNLvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 07:51:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48948 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1JNLvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 07:51:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4yqdwaTxi=KMcgokb05uWUNi5_7uZDGqA4RsOZkWZ7FQA@mail.gmail.com>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	<1318489410-3182-1-git-send-email-jaswinder.singh@linaro.org>
	<CAGsJ_4yqdwaTxi=KMcgokb05uWUNi5_7uZDGqA4RsOZkWZ7FQA@mail.gmail.com>
Date: Fri, 14 Oct 2011 17:21:07 +0530
Message-ID: <CAJe_ZhfomhARd8EVcR+jCHuFLrAKkNqvaETFHiNtNeijx+5Kxw@mail.gmail.com>
Subject: Re: [PATCHv5] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vkoul@infradead.org, rmk@arm.linux.org.uk,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 October 2011 13:02, Barry Song <21cnbao@gmail.com> wrote:
>> diff --git a/Documentation/dmaengine.txt b/Documentation/dmaengine.txt
>> index 94b7e0f..962a2d3 100644
>> --- a/Documentation/dmaengine.txt
>> +++ b/Documentation/dmaengine.txt
>> @@ -75,6 +75,10 @@ The slave DMA usage consists of following steps:
>>    slave_sg    - DMA a list of scatter gather buffers from/to a peripheral
>>    dma_cyclic  - Perform a cyclic DMA operation from/to a peripheral till the
>>                  operation is explicitly stopped.
>> +   interleaved_dma - This is common to Slave as well as M2M clients. For slave
>> +                address of devices' fifo could be already known to the driver.
>> +                Various types of operations could be expressed by setting
>> +                appropriate values to the 'dmaxfer_template' members.
>>
>>    A non-NULL return of this transfer API represents a "descriptor" for
>>    the given transaction.
>> @@ -89,6 +93,10 @@ The slave DMA usage consists of following steps:
>>                struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
>>                size_t period_len, enum dma_data_direction direction);
>>
>> +       struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
>> +               struct dma_chan *chan, struct dmaxfer_template *xt,
>> +               unsigned long flags);
>> +
>
> what if i want a cyclic interleaved transfer? i think the cyclic
> interleaved transfer is what i want for audio dma.
>
... we need to restore 'bool frm_irq' and add new 'bool cyclic' that
would replay the transfer(i.e, reset dma-pointers to src_start & dst_start)
after 'numf' frames have been transferred.
