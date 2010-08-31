Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab0HaNwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 09:52:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34048 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757388Ab0HaNw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 09:52:29 -0400
Date: Tue, 31 Aug 2010 09:52:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Clemens Ladisch <clemens@ladisch.de>
cc: Simon Arlott <simon@fire.lp0.eu>, Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: output an error message when the pipe type doesn't
 match the endpoint type
In-Reply-To: <4C7CA411.5070601@ladisch.de>
Message-ID: <Pine.LNX.4.44L0.1008310951090.1538-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010, Clemens Ladisch wrote:

> Simon Arlott wrote:
> > Commit f661c6f8c67bd55e93348f160d590ff9edf08904 adds a check of the pipe type if
> > CONFIG_USB_DEBUG is enabled,
> 
> I didn't see that commit last year, but wouldn't it break devices like
> the ESI MIDI Mate whose descriptors want to have low-speed bulk transfers
> and where the driver has to submit interrupt transfers instead to get it
> to work at all?

When the kernel sees those invalid low-speed bulk endpoint descriptors,
it changes its internal copy of the descriptor to interrupt.  Hence
when the driver submits interrupt URBs, they work correctly.

Alan Stern

