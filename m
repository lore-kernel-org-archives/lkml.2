Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934400Ab1FWStv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:49:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57382 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933155Ab1FWStu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:49:50 -0400
Date: Thu, 23 Jun 2011 14:49:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
cc: stable@kernel.org, <linux-kernel@vger.kernel.org>,
        <stable-review@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [34-longterm 094/247] OHCI: work around for nVidia shutdown
 problem
In-Reply-To: <1308850515-15242-35-git-send-email-paul.gortmaker@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1106231448480.2033-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011, Paul Gortmaker wrote:

> From: Alan Stern <stern@rowland.harvard.edu>
> 
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
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

This commit caused problems on systems using later NVIDIA hardware.  It 
shouldn't be merged unless the upstream commit

2b7aaf503d56216b847c8265421d2a7d9b42df3e

is merged also.

Alan Stern

