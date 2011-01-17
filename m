Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1AQWl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 17:41:59 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:3400 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753068Ab1AQWl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 17:41:58 -0500
Message-ID: <4D34C5BF.2070107@bluewatersys.com>
Date: Tue, 18 Jan 2011 11:42:07 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Hong Xu <hong.xu@atmel.com>
CC: linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jamie@jamieiles.com, jacmet@sunsite.dk,
        nicolas.ferre@atmel.com
Subject: Re: [PATCH] MTD: atmel_nand: Add DMA support to access Nandflash
References: <hong.xu@atmel.com> <1295248809-30334-2-git-send-email-hong.xu@atmel.com> <4D34A37E.1060300@bluewatersys.com>
In-Reply-To: <4D34A37E.1060300@bluewatersys.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2011 09:15 AM, Ryan Mallon wrote:
> On 01/17/2011 08:20 PM, Hong Xu wrote:
>> Some SAM9 chips have the ability to perform DMA between CPU and SMC controller.
>> This patch adds DMA support for SAM9RL, SAM9G45, SSAM9G46,AM9M10, SAM9M11.

I'm trying to patch this into a 2.6.33 kernel running on a custom
SAM9G45 based board, but I get a failure requesting the DMA channel:

root@snapper:~$ dmesg | grep -i dma
[    0.850000] atmel_nand atmel_nand: Failed to request DMA channel
[    0.860000] atmel_nand atmel_nand: No DMA support for NAND access.
[    1.530000] at_hdmac at_hdmac: Atmel AHB DMA Controller ( cpy slave ), 8 channels


It looks like the registration for the DMA controller happens after the
NAND driver probe and so the request is failing. I had a quick look, but
I can't see anything that would change this in more recent kernels. Any
ideas?

Also, I think you want to add the following for the atmel_nand Kconfig:
  select AT_HDMAC

or make the DMA parts of the driver ifdef CONFIG_AT_HDMAC (if the above
won't work for some reason) since you will get build errors on the
dmaengine functions otherwise.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751 
Fax:   +64 3 3779135			  USA 1800 261 2934

