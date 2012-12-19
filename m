Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2LSPJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:09:37 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:55779 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab2LSPJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:09:29 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RFC] spidev.c: add sysfs attributes for SPI configuration
To: Federico Vaga <federico.vaga@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>
In-Reply-To: <1353777608-24934-1-git-send-email-federico.vaga@gmail.com>
References: <1353777608-24934-1-git-send-email-federico.vaga@gmail.com>
Date: Wed, 19 Dec 2012 15:09:25 +0000
Message-Id: <20121219150925.8262E3E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2012 18:20:08 +0100, Federico Vaga <federico.vaga@gmail.com> wrote:
> This patch introduce the use of the sysfs attribute for the spidev
> configuration. This avoid the user to have a specific program which does
> ioctl() on spidev. The user can easily does cat (to read) and echo (to
> write) on the sysfs file and configure SPI.
> 
> The patch exports the following attributes: bits-per-word, lsb-first,
> mode and speed-hz.
> 
> Example:
>     # cat /sys/bus/spi/devices/spi1.0/speed-hz
>     500000
>     # echo 450000 > /sys/bus/spi/devices/spi1.0/speed-hz
>     # dmesg | tail -n 4
>     spidev spi1.0: DEactivate 60, mr 000f0011
>     spidev spi1.0: setup: 449447 Hz bpw 8 mode 0x0 -> csr0 0000dd02
>     spidev spi1.0: setup mode 0, 8 bits/w, 450000 Hz max --> 0
>     spidev spi1.0: 450000 Hz (max)
> 
> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>

Not a good idea. sysfs is not a good place for operational interfaces.
Please use the spi character devices for direct manipulation of the SPI
configuration.

g.
