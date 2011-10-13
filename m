Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab1JMJ46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:56:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51673 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab1JMJ44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:56:56 -0400
Message-ID: <4E96B5E4.1040602@monstr.eu>
Date: Thu, 13 Oct 2011 11:56:52 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-serial@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: Using serial driver 16550A in poll mode without interrupt connected
References: <4E95902B.7080204@monstr.eu> <20111012145153.5490b592@lxorguk.ukuu.org.uk>
In-Reply-To: <20111012145153.5490b592@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Driver is probed with no IRQ (NO_IRQ = -1 on Microblaze)
>> 83e00000.serial: ttyS0 at MMIO 0x83e01003 (irq = -1) is a 16550A
> 
> Zero means no IRQ. NO_IRQ is a legacy internal thing for the old IDE code
> so not something other code should be using. Setting the IRQ to -1 is
> bogus and will confuse the rest of the kernel.

It is on my list. There are still some archs (ARM, etc) which still use it.

> 
>> Is it possible to use serial driver without IRQ - or blocking IRQ, etc.?
> 
> Within limits - it kills your power management and data rates because of
> the continual polling.

Microblaze does nothing with power management and data rates is no problem -
it could exchange some data to check actual status or so.

We just need to make a decision about generating compatible properties for
serial IPs without IRQ. Our BSP which generate dts from Xilinx tools is able
to check if IRQ is connected and based on that do any action - show error/warning/ignore.

If compatible string is not in DTS driver for this IP is not probed.
If you are saying that Linux serial drivers are not prepared for polling because of any reason
we will handle that in BSP.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
