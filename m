Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab0FCMXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:23:15 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:52331 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab0FCMXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:23:14 -0400
Date: Thu, 3 Jun 2010 14:23:09 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Johan Hovold <jhovold@gmail.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb-serial/ftdi_sio: fix DTR/RTS line modes
Message-ID: <20100603122309.GJ2698@buzzloop.caiaq.de>
References: <1275566102-5613-1-git-send-email-daniel@caiaq.de>
 <20100603123225.55f544ff@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603123225.55f544ff@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 12:32:25PM +0100, Alan Cox wrote:
> On Thu,  3 Jun 2010 13:55:02 +0200
> Daniel Mack <daniel@caiaq.de> wrote:
> 
> > Call set_mctrl() and clear_mctrl() according to the flow control mode
> > selected. This makes serial communication for FT232 connected devices
> > work when CRTSCTS is not set.
> > 
> > This fixes a regression introduced by 4175f3e31 ("tty_port: If we are
> > opened non blocking we still need to raise the carrier"). This patch
> > calls the low-level driver's dtr_rts() function which consequently
> > sets TIOCM_DTR | TIOCM_RTS. A later call to set_termios() without
> > CRTSCTS in cflags, however, does not reset these bits, and so data is
> > not actually sent out on the serial wire.
> 
> If you've got hardware the other end expecting RTS/CTS signals you
> really ought to set CRTSCTS. 

I know. It is, however, a regression in my case, and there might be
other cases where RTS/CTS aren't connected at all. The core of the
problem is that the driver sets hardware flow control, even though the
userspace asked for not doing that.

> However you patch makes complete sense in
> terms of which way it is best to end up.

And it shouldn't break anything I'd say.

Thanks,
Daniel

