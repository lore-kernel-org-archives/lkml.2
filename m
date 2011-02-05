Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab1BERl4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:41:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:41823 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab1BERlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:41:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,431,1291622400"; 
   d="scan'208";a="654743577"
Message-ID: <4D4D8BD8.2050709@intel.com>
Date: Sat, 05 Feb 2011 09:41:44 -0800
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: mahdi hamzeh <mahdy.hamzeh@gmail.com>
CC: Paul Mundt <lethal@linux-sh.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: DMA
References: <AANLkTimW-PT801BUL8QQkhVpezX_VNw-1qLNRpeeoQFU@mail.gmail.com>	<AANLkTinQWLOOSMS_8LcFkSmRT2K_CbQ+v2pH7FiNxqGo@mail.gmail.com>	<AANLkTimC=6TA8eF6jFYzm_3RzXkQo9BwCMexdjfPKtEC@mail.gmail.com>	<AANLkTinFJ54dCJPLANOmwejrBrb=vw0m-BLtq9a7ys5s@mail.gmail.com>	<AANLkTimiLJz-F3QMppVjh9ZaF8JbGeRawPgNme1dWjVJ@mail.gmail.com>	<20110125071502.GH11673@linux-sh.org> <AANLkTikSu2xo2VDLvvqoGWbAv8b_ZX9xvdjRGrUDb8Vt@mail.gmail.com>
In-Reply-To: <AANLkTikSu2xo2VDLvvqoGWbAv8b_ZX9xvdjRGrUDb8Vt@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2011 01:01 PM, mahdi hamzeh wrote:
> Paul,
>
> Thanks for your help. You were right. There was a version mismatch
> between my header files and I got it fixed. I could compile all
> related dma modules including async modules. However, I cannot use dma
> engine because I receive following error when I run my code,
> "__dma_request_channel: fail ((null))". Even I tried
> Documentation/crypto/async-tx-api.txt but it turns out that when I
> issue a transaction such that "async_memcpy" and I wait for
> transaction to be completed by "wait_for_completion", it is never
> completed. Is this problem related to my machine or my code?
>
> Here is my code:
>
> struct async_submit_ctl submit;
> struct completion cmp;
> init_completion(&cmp);
> init_async_submit(&submit, flag, NULL, NULL,&cmp,  addr_conv);
                                          ^^^^
Hmm... what's wrong with this parameter? ;-)

> dma_cap_mask_t myMask;
> dma_cap_zero(myMask);
> dma_cap_set(DMA_PRIVATE, myMask); //I tried different combination of
> flags like DMA_MEMCPY ,....
> myDMAChannel = dma_request_channel(myMask, NULL, filter_param);
>
> myDMAChannel is always NULL.

This is a bit more subtle.  Depending on the driver and the kernel 
configuration all channels may already be consumed for "public" usage 
(NET_DMA and/or ASYNC_TX_DMA).

One way to sanity check your system is to turn off CONFIG_NET_DMA and 
CONFIG_ASYNC_TX_DMA and turn on CONFIG_DMATEST, load dmatest.ko and it 
should give a clue about whether dma is operational on your platform.

--
Dan
