Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab0LFJiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 04:38:08 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42927 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673Ab0LFJiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 04:38:05 -0500
X-Sasl-enc: antecmGmXvtxoRMDD7MrB2c9SlWg3zZ7Y2t4iWDD3EsU 1291628284
Message-ID: <4CFCAF71.2050907@ladisch.de>
Date: Mon, 06 Dec 2010 10:40:01 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Robin Cook <rcook@wyrms.net>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel <linux1394-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: Issue with firewire from 2.6.35.9 to 2.6.36.1
References: <1291592226.7134.1.camel@pheuri.wyrms.net>	<1291594279.9196.2.camel@maxim-laptop> <20101206082918.6d1ccc41@stein>
In-Reply-To: <20101206082918.6d1ccc41@stein>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> > On Sun, 2010-12-05 at 17:37 -0600, Robin Cook wrote:
> > > I recently upgraded from 26.35.9 to 2.6.36.1 and now the /dev/fwX
> > > devices are not being created.  I have udev 164 installed.
> > > 
> > > 2.6.35.9 dmesg firewire lines...
> > > 
> > > firewire_ohci 0000:07:00.0: PCI INT A -> GSI 44 (level, low) -> IRQ 44
> > > firewire_ohci 0000:07:00.0: setting latency timer to 64
> > > firewire_ohci: Added fw-ohci device 0000:07:00.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x1
> > > firewire_core: created device fw0: GUID 0010dc0001adc862, S400
> > > firewire_core: created device fw1: GUID 00808803072803a5, S100
> > > firewire_core: phy config: card 0, new root=ffc1, gap_count=5
> > > 
> > > 2.6.36.1 dmesg firewire lines...
> > > 
> > > firewire_ohci 0000:07:00.0: PCI INT A -> GSI 44 (level, low) -> IRQ 44
> > > firewire_ohci 0000:07:00.0: setting latency timer to 64
> > > firewire_ohci 0000:07:00.0: irq 75 for MSI/MSI-X
> > > firewire_ohci: Added fw-ohci device 0000:07:00.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x1
> 
> ... Rather, MSI support
> (messages signaled interrupts, added to firewire-ohci in kernel 2.6.36)
> of your controller might be buggy.

I'd guess if you check in /proc/interrupts you see that no interrupts
have arrived for IRQ 75 (firewire-ohci).

> Which controller do you have according to "lspci -nn"?

"0010DC" is MSI.  I've heard about VT6315 and JMB381 controllers on
their mainboards; since the driver tries to enable MSI, it must be the
VT6315.


Regards,
Clemens
