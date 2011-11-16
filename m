Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab1KPWsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 17:48:12 -0500
Received: from mail.vyatta.com ([76.74.103.46]:42851 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab1KPWsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 17:48:11 -0500
Date: Wed, 16 Nov 2011 14:48:06 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Sven Joachim <svenjoac@gmx.de>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: sky2 driver breaks reboot/shutdown
Message-ID: <20111116144806.0b6e327f@nehalam.linuxnetplumber.net>
In-Reply-To: <878vnfpy6y.fsf@turtle.gmx.de>
References: <878vnfpy6y.fsf@turtle.gmx.de>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011 22:14:13 +0100
Sven Joachim <svenjoac@gmx.de> wrote:

> [ Resending since my first attempt apparently did not make it to the
>   mailing lists.  Apologies to anyone who receives duplicates. ]
> 
> Hi,
> 
> after upgrading from Linux 3.1 to 3.2-rc2 I noticed that the kernel
> would no longer reboot or shutdown properly, hanging instead.  Removing
> the sky2 driver works around this.  According to "lspci -v", I have the
> following network card:
> 
> ,----
> | 03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 13)
> | 	Subsystem: ABIT Computer Corp. Device 108f
> | 	Flags: bus master, fast devsel, latency 0, IRQ 17
> | 	Memory at fdefc000 (64-bit, non-prefetchable) [size=16K]
> | 	I/O ports at ce00 [size=256]
> | 	[virtual] Expansion ROM at fdd00000 [disabled] [size=128K]
> | 	Capabilities: <access denied>
> | 	Kernel driver in use: sky2
> `----
> 
> Bisecting shows 0bdb0bd01 as the first bad commit:
> 

Already reported. I am testing a fix. The hang is happening in synchronize_irq
in sky2_hw_all_down; but there are several other bugs that were introduced at the
same time.
