Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761092Ab0J1U5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:57:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54498 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759653Ab0J1U5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:57:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Timur Tabi <timur@freescale.com>
Subject: Re: Writing a console/tty driver -- how to use tty_port?
Date: Thu, 28 Oct 2010 22:57:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36+; KDE/4.5.1; x86_64; ; )
Cc: gregkh <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>
References: <4CC893CD.7020701@freescale.com>
In-Reply-To: <4CC893CD.7020701@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010282257.33898.arnd@arndb.de>
X-Provags-ID: V02:K0:i9np8AB56myNcXoXk+B8rIqM8AGwQQQll6ugWhSOwed
 /0UhPti/Tsb3TOKDMSfyQhgnJBjNO3c3XdQMGQxRj9wqu6SFnR
 BrGYjpEo/CyqLNG0CNoJe90X5C2xAjifXC8oKuEFLPsVa/nI4z
 DMURtS+OVKBHAiKUIhM4NwVQ90QamG/Adn9jT2vSPMn74n0RHq
 m/kMykoOLIhQdDec5dIMw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 October 2010 23:04:13 Timur Tabi wrote:
> Do you have an updated version of Tiny TTY that uses tty_port structures?  I'm
> trying to write a new TTY driver for a device that is not a UART, and I'm having
> a hard time finding a good example.  I suspect I need to understand the tty_port
> structure, but I can't find any documentation for it.

If the device is not a UART, the best option may be to make the driver
a backend to the hvc driver, like e.g. drivers/char/hvc_tile.c.

This works for all devices with or without interrupts that don't need
to set up the communication parameters but simply provide a read/write
character interface.

	Arnd
