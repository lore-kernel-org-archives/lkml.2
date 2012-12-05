Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2LER6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 12:58:50 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35460 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab2LER6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 12:58:49 -0500
Date: Wed, 05 Dec 2012 12:58:47 -0500 (EST)
Message-Id: <20121205.125847.649579012053540438.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, manabian@gmail.com,
        plagnioj@jcrosoft.com
Subject: Re: [PATCH] net/macb: increase RX buffer size for GEM
From: David Miller <davem@davemloft.net>
In-Reply-To: <50BF6366.8080600@atmel.com>
References: <1354536943-6356-1-git-send-email-nicolas.ferre@atmel.com>
	<20121204.132227.1430662061932892582.davem@davemloft.net>
	<50BF6366.8080600@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Wed, 5 Dec 2012 16:08:22 +0100

> On 12/04/2012 07:22 PM, David Miller :
>> From: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Date: Mon, 3 Dec 2012 13:15:43 +0100
>> 
>>> Macb Ethernet controller requires a RX buffer of 128 bytes. It is
>>> highly sub-optimal for Gigabit-capable GEM that is able to use
>>> a bigger DMA buffer. Change this constant and associated macros
>>> with data stored in the private structure.
>>> I also kept the result of buffers per page calculation to lower the
>>> impact of this move to a variable rx buffer size on rx hot path.
>>> RX DMA buffer size has to be multiple of 64 bytes as indicated in
>>> DMA Configuration Register specification.
>>>
>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> 
>> This looks like it will waste a couple hundred bytes for 1500 MTU
>> frames, am I right?
> 
> Yep! But buffers get recycled, and with the current memory management by
> pages, it seems that I have to rework some part of it to optimize this
> memory usage (8KB memory blocks split into 5 buffers each as David said...).
> 
> Do you think it is worth digging this way or may I rework the rx buffer
> management in case of the GEM interface. If I implement a different path
> for GEM interface, I will have the possibility to tailor rx DMA buffers
> from 1500 Bytes up to 10KB jumbo frames...

I almost think you have to.
