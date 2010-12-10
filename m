Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab0LJKhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:37:22 -0500
Received: from mail.atmel.fr ([81.80.104.162]:52023 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab0LJKhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:37:20 -0500
Message-ID: <4D0202D2.8010208@atmel.com>
Date: Fri, 10 Dec 2010 11:37:06 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] scatterlist: Initialize the dma_address field with
 invalid dma address
References: <1291900514-7290-1-git-send-email-nicolas.ferre@atmel.com> <20101209.120006.189701386.davem@davemloft.net>
In-Reply-To: <20101209.120006.189701386.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 09/12/2010 21:00, David Miller :
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
> Date: Thu,  9 Dec 2010 14:15:14 +0100
> 
>> Initialize the the dma_address field so that it will be possible to test
>> its value while using scatterlists. This field will be compatible with
>> testing by dma_mapping_error().
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Please don't do this, it's unjustified and it's going to kill performance.

Yes, that is what I suspected...

> Even if it were a good change, you should have used the invalid DMA
> address definition defined by various architectures instead of a constant.

Well this definition seems to be spread among drivers (mostly usb ones):
DMA_ADDR_INVALID...
And also sometimes with different names:
DMA_INVALID_HANDLE, INVALID_DMA_ADDRESS

> You should be aware of whether entries in a scatterlist have been setup
> by your code path.

Yes, in fact my need is related to the fact that my scatterlist is
filled in a driver and then handled by the dmaengine driver.
But I will reconsider the path taken by my sg to be able to avoid
checking the dma_address field.

Best regards,
-- 
Nicolas Ferre
