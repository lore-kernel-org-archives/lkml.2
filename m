Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1F2G2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 02:28:18 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:52947 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab1F2G2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 02:28:14 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: [PATCH] pch_dma: Fix channel locking
Date: Wed, 29 Jun 2011 08:28:02 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        "Wang, Qi" <qi.wang@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>
References: <1308755133-8605-1-git-send-email-alexander.stein@systec-electronic.com> <201106271622.52763.alexander.stein@systec-electronic.com> <4E09AE3A.8050306@dsn.okisemi.com>
In-Reply-To: <4E09AE3A.8050306@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <201106290828.06508.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 June 2011 12:34:34 Tomoya MORINAGA wrote:
> (2011/06/27 23:22), Alexander Stein wrote:
> > Ok. I have a 2.6.39 kernel with the following patches:
> > pch_phub: Don't panic if dmi_get_system_info returns NULL
> > drivers/tty/serial/pch_uart.c: don't oops if dmi_get_system_info returns
> > NULL pch_uart: Add console support
> > 
> > I need these to get a booting board with console support on pch_uart.
> > After boot (dma and pch_uart compiled into kernel), I do
> > * setserial /dev/ttyPCH0 ^low_latency
> > * ./raise_dma_fault
> > <- Here I get the message
> 
> Thank you for your information.
> I could see the kernel message.
> However using your patch, it seems the message remains to be seen.
> 
> [  142.401597] pch_uart 0000:02:0a.1: PCH UART : Use DMA Mode
> [  148.011410]
> [  148.011415] =================================
> [  148.011428] [ INFO: inconsistent lock state ]
> [  148.011439] 2.6.39.2+ #5
> [  148.011446] ---------------------------------
> [  148.011455] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> [  148.011467] gnome-terminal/1759 [HC1[1]:SC0[0]:HE0:SE1] takes:
> [  148.011477]  (&(&pd_chan->lock)->rlock){?.....}, at: [<c0710cc5>]
> pd_prep_slave_sg+0x92/0x26d
> [  148.011509] {HARDIRQ-ON-W} state was registered at:
> [  148.011516]   [<c04618a1>] __lock_acquire+0x2d9/0xbcc
> [  148.011533]   [<c0462594>] lock_acquire+0x94/0xb7
> [  148.011546]   [<c07cec85>] _raw_spin_lock_bh+0x25/0x34
> [  148.011561]   [<c07110d0>] pd_alloc_chan_resources+0xb2/0x165

Are you sure you applied the patch? There shouldn't be a _raw_spin_lock_bh 
here.

Regards,
Alexander
