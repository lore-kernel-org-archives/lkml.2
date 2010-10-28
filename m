Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546Ab0J1VIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:08:36 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:53179
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759808Ab0J1VI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:08:29 -0400
X-SpamScore: -5
X-BigFish: VS-5(z3b68iz98dNzz1202hzz8275dhz2dh2a8h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw02.freescale.net;RD:de01egw02.freescale.net;EFVD:NLI
Message-ID: <4CC9E646.6070405@freescale.com>
Date: Thu, 28 Oct 2010 16:08:22 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.13) Gecko/20101013 Fedora/2.0.8-2.fc13 SeaMonkey/2.0.8
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: gregkh <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Writing a console/tty driver -- how to use tty_port?
References: <4CC893CD.7020701@freescale.com> <201010282257.33898.arnd@arndb.de>
In-Reply-To: <201010282257.33898.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Oct 2010 21:08:54.0554 (UTC) FILETIME=[5415FFA0:01CB76E4]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> If the device is not a UART, the best option may be to make the driver
> a backend to the hvc driver, like e.g. drivers/char/hvc_tile.c.

The current version *is* a backend to hvc, but I have to abandon that because of
this thread:

http://lists.ozlabs.org/pipermail/linuxppc-dev/2010-September/085664.html

I posted a patch that causes hvc to spin if the backend driver returns -EAGAIN,
which is my driver does when the output buffer is full.

In other words, hvc does not support backend drivers that can detect full output
buffers.

> This works for all devices with or without interrupts that don't need
> to set up the communication parameters but simply provide a read/write
> character interface.

If my patch were accepted, I wouldn't need to do the rewrite.  Dropping
characters during a printk() is not acceptable for us.

-- 
Timur Tabi
Linux kernel developer at Freescale

