Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab1DYVYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:24:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48118 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755314Ab1DYVYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 17:24:37 -0400
Date: Mon, 25 Apr 2011 17:24:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Willy Tarreau <w@1wt.eu>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
        <stable@kernel.org>, <stable-review@kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 039/173] OHCI: work around for nVidia shutdown problem
In-Reply-To: <20110425200234.685881927@pcw.home.local>
Message-ID: <Pine.LNX.4.44L0.1104251722470.1741-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011, Willy Tarreau wrote:

> 2.6.27.59-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> commit 3df7169e73fc1d71a39cffeacc969f6840cdf52b upstream.
> 
> This patch (as1417) fixes a problem affecting some (or all) nVidia
> chipsets.  When the computer is shut down, the OHCI controllers
> continue to power the USB buses and evidently they drive a Reset
> signal out all their ports.  This prevents attached devices from going
> to low power.  Mouse LEDs stay on, for example, which is disconcerting
> for users and a drain on laptop batteries.
> 
> The fix involves leaving each OHCI controller in the OPERATIONAL state
> during system shutdown rather than putting it in the RESET state.
> Although this nominally means the controller is running, in fact it's
> not doing very much since all the schedules are all disabled.  However
> there is ongoing DMA to the Host Controller Communications Area, so
> the patch also disables the bus-master capability of all PCI USB
> controllers after the shutdown routine runs.
> 
> The fix is applied only to nVidia-based PCI OHCI controllers, so it
> shouldn't cause problems on systems using other hardware.  As an added
> safety measure, in case the kernel encounters one of these running
> controllers during boot, the patch changes quirk_usb_handoff_ohci()
> (which runs early on during PCI discovery) to reset the controller
> before anything bad can happen.
> 
> Reported-by: Pali Rohár <pali.rohar@gmail.com>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: David Brownell <david-b@pacbell.net>
> Tested-by: Pali Rohár <pali.rohar@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Some people have reported that more recent Nvidia systems work
correctly without this patch and have problems when the patch is
applied.  For now, I suggest omitting this patch.

Alan Stern

