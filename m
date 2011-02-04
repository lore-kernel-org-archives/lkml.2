Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1BDVBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:01:54 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46985 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab1BDVBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:01:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VvMRZLjbthQrehMoB2fGQja3h8x7KJQUzZAlmMBNuZ4gPA5d2SZZR3X9N96NzM1dLB
         vWjbfRStZNiKBQ4MwdKSmL+BdcxEdIYrf5/Pv5rk5l14d8a36wwVBJsJnyIhsA0jGmOJ
         /6VZOVpxFiTM+ykknCJCw+gLLvew9aiFvOBJ0=
MIME-Version: 1.0
In-Reply-To: <20110125071502.GH11673@linux-sh.org>
References: <AANLkTimW-PT801BUL8QQkhVpezX_VNw-1qLNRpeeoQFU@mail.gmail.com>
	<AANLkTinQWLOOSMS_8LcFkSmRT2K_CbQ+v2pH7FiNxqGo@mail.gmail.com>
	<AANLkTimC=6TA8eF6jFYzm_3RzXkQo9BwCMexdjfPKtEC@mail.gmail.com>
	<AANLkTinFJ54dCJPLANOmwejrBrb=vw0m-BLtq9a7ys5s@mail.gmail.com>
	<AANLkTimiLJz-F3QMppVjh9ZaF8JbGeRawPgNme1dWjVJ@mail.gmail.com>
	<20110125071502.GH11673@linux-sh.org>
Date: Fri, 4 Feb 2011 14:01:40 -0700
Message-ID: <AANLkTikSu2xo2VDLvvqoGWbAv8b_ZX9xvdjRGrUDb8Vt@mail.gmail.com>
Subject: Re: DMA
From: mahdi hamzeh <mahdy.hamzeh@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

Thanks for your help. You were right. There was a version mismatch
between my header files and I got it fixed. I could compile all
related dma modules including async modules. However, I cannot use dma
engine because I receive following error when I run my code,
"__dma_request_channel: fail ((null))". Even I tried
Documentation/crypto/async-tx-api.txt but it turns out that when I
issue a transaction such that "async_memcpy" and I wait for
transaction to be completed by "wait_for_completion", it is never
completed. Is this problem related to my machine or my code?

Here is my code:

struct async_submit_ctl submit;
struct completion cmp;
init_completion(&cmp);
init_async_submit(&submit, flag, NULL, NULL, &cmp,  addr_conv);
desc=async_memcpy(dest, src, 0, 0, 10,  &submit);
async_tx_issue_pending_all();
wait_for_completion(&cmp);

My other code:

dma_cap_mask_t myMask;
dma_cap_zero(myMask);
dma_cap_set(DMA_PRIVATE, myMask); //I tried different combination of
flags like DMA_MEMCPY ,....
myDMAChannel = dma_request_channel(myMask, NULL, filter_param);

myDMAChannel is always NULL.


Thanks

On Tue, Jan 25, 2011 at 12:15 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Mon, Jan 24, 2011 at 04:04:57PM -0700, mahdi hamzeh wrote:
>> I am working on a research project for which I should be able to
>> transfer data from memory to memory using DMA. I am working on a x86
>> machine but I want my code to be architecture independent as much as
>> possible. Please?accept?my?apology?if my question is too basic to be
>> asked from this mailing list. Here is my problem:
>> I?used "struct dma_chan" to define a channel structure but when I use
>> "dma_request_channel" function to get a DMA channel, with all
>> different possible masks including?DMA_MEMCPY,?DMA_PRIVATE,....
>> anything, the function returns always NULL. This function is defined
>> in "dmaengine.h".?I also tried a low level function to see dma channel
>> availability?and "request_dma" function defined in "dma.h" works
>> perfect.
>> Any comment, help, document, program, reference anything that helps me
>> to create a simple DMA transaction would really be appreciated.
>> PS: There is a test program called dmatest.c is provided in the linux
>> kernel files. I tried to get it compiled but I could not since the
>> functions and structures used in this file has been changed in the
>> kernel header files.
>>
> I'm not sure how you selected the sh list as the best forum for this
> inquiry (I assume it's because Guennadi has been doing a lot of dmaengine
> driver work recently), but this is really something that's better suited
> for l-k directly, with Dan CC'ed (as I've done here).
>
> If you're looking for preliminary getting started information, then your
> best bet is Documentation/crypto/async-tx-api.txt, as referenced in the
> top-level MAINTAINERS.
>
> The dmatest driver of course also provides you with some examples of how
> to plug in to the API. In any event, I'm able to compile dmatest without
> any difficulty, so I'm not sure what bitrot you are seeing, perhaps it's
> something related to the driver you are using? You'll have to provide the
> relevant bits from your .config or the errors you're seeing before anyone
> will be able to point you in the right direction here.
>



-- 
---Mahdi Hamzeh
