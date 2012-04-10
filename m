Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab2DJB01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 21:26:27 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41235 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab2DJB00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 21:26:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120409174405.GA25990@kroah.com>
References: <1332842162-26113-1-git-send-email-tomoya.rohm@gmail.com>
	<20120409174405.GA25990@kroah.com>
Date: Tue, 10 Apr 2012 10:26:25 +0900
Message-ID: <CANKRQniAUT232kGLY0PmHi_kmXdFWKeX6289qCXkSw6N179yTg@mail.gmail.com>
Subject: Re: [PATCH] pch_uart: Fix dma channel unallocated issue
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 2:44 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>> This driver anticipates pch_uart_verify_port() is not called
>> during installation.
>> However, actually pch_uart_verify_port() is called during
>> installation.
>> As a result, memory access violation occurs like below.
>>
>> 0. initial value: use_dma=0
>> 1. starup()
>>     - dma channel is not allocated because use_dma=0
>> 2. pch_uart_verify_port()
>>     - Set use_dma=1
>> 3. UART processing acts DMA mode because use_dma=1
>>      - memory access violation occurs!
>>
>> This patch fixes the issue.
>>
>> Solution:
>> Whenever pch_uart_verify_port() is called and then
>> dma channel is not allocated, the channel should be allocated.
>>
>> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
>> ---
>>  drivers/tty/serial/pch_uart.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> This patch does not apply to 3.4-rc2, so I can not apply it, sorry.
>
> Care to redo it?

This patch depends on the following patch you've already accepted.

>From 44db113212d86a5870c2bfe8fb767fa842d68805 Mon Sep 17 00:00:00 2001
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Date: Mon, 26 Mar 2012 14:43:00 +0900
Subject: pch_uart: Delete unused structure member

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/pch_uart.c |    2 --
 1 file changed, 2 deletions(-)


So now,  this patch can be applied.
In fact, I've confirmed this patch can be applied to 3.4-rc2 with the
following order.
1st: pch_uart: Delete unused structure member
2nd: pch_uart: Fix dma channel unallocated issue

I should have written the dependency.
Could you try to apply this patch again ?

thanks
-- 
ROHM Co., Ltd.
tomoya
