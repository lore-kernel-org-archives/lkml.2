Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1FWHiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 03:38:15 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:38022 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1FWHiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 03:38:14 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH v2] pch_uart: Add MSI support
Date: Thu, 23 Jun 2011 09:37:17 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <4E02857C.1010304@dsn.okisemi.com> <1308812405-5245-1-git-send-email-alexander.stein@systec-electronic.com> <4E02E856.70007@ladisch.de>
In-Reply-To: <4E02E856.70007@ladisch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106230937.17628.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 June 2011 09:16:38 Clemens Ladisch wrote:
> Alexander Stein wrote:
> > +++ b/drivers/tty/serial/pch_uart.c
> > @@ -1578,6 +1578,8 @@ static struct eg20t_port *pch_uart_init_port(struct
> > pci_dev *pdev,
> > 
> > +	pci_enable_msi(pdev);
> 
> Pretty much every driver that tries this eventually ends up with
> a blacklist of devices that don't implement MSI correctly.
> Did you test this with all the models that are supported by this driver?

I don't have all models supported by this driver. So I could only test with 
this one:
#lspci -v -s 02:0a.1
02:0a.1 Serial controller: Intel Corporation Device 8811 (prog-if 02 [16550])
        Subsystem: Intel Corporation Device 8811
        Flags: bus master, fast devsel, latency 0, IRQ 40
        I/O ports at 9040 [size=8]
        Memory at 9fefb2f0 (32-bit, non-prefetchable) [size=16]
        Capabilities: [40] MSI: Mask- 64bit- Count=1/1 Enable+
        Capabilities: [50] Power Management version 2
        Kernel driver in use: pch_uart

There are 3 more for the other ports.

Regards,
Alexander
