Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab2BQBfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:35:30 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52365 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754860Ab2BQBf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:35:28 -0500
X-Sasl-enc: 0Rt0/rtW6B+Uo87r43MN1ZdqQyPYJoPF1N9LbdLeIrWn 1329442527
Date: Thu, 16 Feb 2012 17:30:12 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: "lkml, " <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: pch_uart and pch_phub clock selection
Message-ID: <20120217013012.GA18530@kroah.com>
References: <4F3DA617.5030805@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3DA617.5030805@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 04:57:59PM -0800, Darren Hart wrote:
> I'm working on a tunnel creek (atom e6xx + topcliff PCH) development platform
> that uses a 48MHz or 64MHz clock to drive the pch_uart. I've found that if I
> force the uart_clock to 48MHz (or 64MHz on the latest rev) I can get the kernel
> messages and getty on the serial port.
> 
> I see that the the CM-iTC board is special-cased to set a 192MHz uart_clock.
> This is done in pch_uart.c code, but there is some register manipulation done in
> the pch_phub.c driver and I don't understand the connection. How are the two
> related?
> 
> Is the pch_phub.c register manipulation required for proper related? It seems to
> work without touching those registers if I just force the clock.
> 
> The device I'm working with is EFI, and the dmi_get_system_info(DMI_BOARD_NAME)
> returns "(null)", so I can't use the same test to identify this board. Is there
> another common mechanism I might be able to use?

There's no relevant DMI information for the board at all?  What does:
	grep . /sys/class/dmi/id/*
show?

> 
> The following patch (by way of example, not meant for inclusion) gets things
> working for this particular board with this command line:
> 
> console=ttyPCH1,115200 pch_uart.clock_param=48000000
> 
> I believe the right thing to do here is to discover a way to identify the board
> and special case the clock as is done for the CM-iTC, but I would like to
> understand the purpose of the pch_phub register manipulation code. Does this
> make sense?
> 
> Thanks,
> 
> Darren
> 
> 
> >From f83fa6cb575844d8e37f136890fe32258eb88dd2 Mon Sep 17 00:00:00 2001
> Message-Id: <f83fa6cb575844d8e37f136890fe32258eb88dd2.1329439822.git.dvhart@linux.intel.com>
> From: Darren Hart <dvhart@linux.intel.com>
> Date: Wed, 15 Feb 2012 15:44:18 -0800
> Subject: [PATCH] pch_uart: Add clock parameter
> 
> Allow for the specification of the clock as a module parameter. This is useful
> when a board uses a non-standard clock, or when different versions of a board
> use different clocks, and that board name or the version are not available to
> the kernel.

You also rename base_baud to uart_clock here, so you might want to
mention it in the changelog entry :)

greg k-h
