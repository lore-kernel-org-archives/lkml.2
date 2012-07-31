Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab2GaH1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 03:27:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37506 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab2GaH1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 03:27:50 -0400
MIME-Version: 1.0
In-Reply-To: <50178249.7090306@ladisch.de>
References: <20120730202401.GA4947@gobelin>
	<20120731064557.GA4676@gobelin>
	<50178249.7090306@ladisch.de>
Date: Tue, 31 Jul 2012 09:27:49 +0200
Message-ID: <CACYmx9O_TJoSmhiai_Mv09JE3HZ+-V=w8KobTn3zPXtkWbojkw@mail.gmail.com>
Subject: Re: About dma_sync_single_for_{cpu,device}
From: Karl Beldan <karl.beldan@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/12, Clemens Ladisch <clemens@ladisch.de> wrote:
> Karl Beldan wrote:
>> To tx a chunk of data from the SoC => network device, we :
>> - prepare a buffer with a leading header embedding a pattern,
>> - trigger the xfer and wait for an irq
>> // The device updates the pattern and then triggers an irq
>> - upon irq we check the pattern for the xfer completion
>>
>> I was expecting the following to work:
>> 	addr = dma_map_single(dev, buffer, size, DMA_TO_DEVICE);
>
> Of both the CPU and the device write to the buffer, you must use
> DMA_BIDIRECTIONAL.
>
Hi Clemens,

This does not work (tested) :  seems to me BIDIRECTIONAL would just
add invalidate, and invalidate before the ram has been updated, as
stated, does not work.
In fact the immediately following sync_for_device is intended to cater
for what DMA_BIDIRECTIONAL would provide (though it is not
implementation agnostic), only  invalidating a smaller address range.

Regards,

Karl
