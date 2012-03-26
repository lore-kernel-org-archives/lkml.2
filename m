Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab2CZUb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:31:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47796 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab2CZUb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:31:27 -0400
Date: Mon, 26 Mar 2012 13:31:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: ftdi_sio: fix status line change handling for TIOCMIWAIT and
 TIOCGICOUNT
Message-ID: <20120326203123.GA26899@kroah.com>
References: <4F70CF5C.7030004@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F70CF5C.7030004@simon.arlott.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 09:19:40PM +0100, Simon Arlott wrote:
> Handling of TIOCMIWAIT was changed by commit 1d749f9afa657f6ee9336b2bc1fcd750a647d157
>  USB: ftdi_sio.c: Use ftdi async_icount structure for TIOCMIWAIT, as in other drivers
> 
> FTDI_STATUS_B0_MASK does not indicate the changed modem status lines,
> it indicates the value of the current modem status lines. An xor is
> still required to determine which lines have changed.
> 
> The count was only being incremented if the line was high. The only
> reason TIOCMIWAIT still worked was because the status packet is
> repeated every 1ms, so the count was always changing. The wakeup
> itself still ran based on the status lines changing.
> 
> This change fixes handling of updates to the modem status lines and
> allows multiple processes to use TIOCMIWAIT concurrently.
> 
> Tested with two processes waiting on different status lines being
> toggled independently.

Nice, do you happen to have the source for such a test tool anywhere
around?  I'd like to use it for future testing if at all possible.

I'll queue this up after 3.4-rc1 is out.

greg k-h
