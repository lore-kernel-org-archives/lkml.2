Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab2GaHeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 03:34:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58494 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309Ab2GaHeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 03:34:06 -0400
X-Sasl-enc: m4s4y1pwZwpiV4o2cjdxrjEZb0JhtKUVhsICr9zbynj9 1343720042
Message-ID: <50178A69.8050906@ladisch.de>
Date: Tue, 31 Jul 2012 09:34:01 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: About dma_sync_single_for_{cpu,device}
References: <20120730202401.GA4947@gobelin> <20120731064557.GA4676@gobelin> <50178249.7090306@ladisch.de> <CACYmx9O_TJoSmhiai_Mv09JE3HZ+-V=w8KobTn3zPXtkWbojkw@mail.gmail.com>
In-Reply-To: <CACYmx9O_TJoSmhiai_Mv09JE3HZ+-V=w8KobTn3zPXtkWbojkw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Beldan wrote:
> On 7/31/12, Clemens Ladisch <clemens@ladisch.de> wrote:
>> Karl Beldan wrote:
>>> To tx a chunk of data from the SoC => network device, we :
>>> - prepare a buffer with a leading header embedding a pattern,
>>> - trigger the xfer and wait for an irq
>>> // The device updates the pattern and then triggers an irq
>>> - upon irq we check the pattern for the xfer completion
>>>
>>> I was expecting the following to work:
>>> 	addr = dma_map_single(dev, buffer, size, DMA_TO_DEVICE);
>>
>> Of both the CPU and the device write to the buffer, you must use
>> DMA_BIDIRECTIONAL.
>
> This does not work (tested) :  seems to me BIDIRECTIONAL would just
> add invalidate, and invalidate before the ram has been updated, as
> stated, does not work.

Please show the exact sequence of dma_* calls, and also show when and
how the CPU and the device access the buffer.


Regards,
Clemens
