Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab2GZV2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:28:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46722 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2GZV2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:28:11 -0400
Date: Thu, 26 Jul 2012 14:28:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: No big TTY/serial patch merge for 3.6-rc1
Message-ID: <20120726212807.GA9049@kroah.com>
References: <20120726190814.GA2194@kroah.com>
 <20120726222313.5993a550@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120726222313.5993a550@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 10:23:13PM +0100, Alan Cox wrote:
> On Thu, 26 Jul 2012 12:08:14 -0700
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> >       tty: Move the handling of the tty release logic
> 
> Can we lose that one specifically. I've chased down Ian Abbotts problem
> and replicated it and that is the offending patch not the lock localise
> (which still needs to be kept out as it depends upon this one)
> 
> I have it fixed but it's not had enough testing for -rc1 and moving the
> termios data has enough spectacular hits all drivers fallout for 3.6

Yes, I can go revert it.  I'm working on building up a small tty-linus
branch at the moment for just the "must haves" for 3.6.  Right now it's
just 10 patches listed below.  Any objection to me sending these after
a round trip through linux-next?

thanks,

greg k-h


 .../devicetree/bindings/tty/serial/of-serial.txt   |    1 +
 drivers/tty/serial/8250/8250.c                     |    8 +++
 drivers/tty/serial/of_serial.c                     |    1 +
 drivers/tty/serial/pch_uart.c                      |   59 +++++++++++++-------
 drivers/tty/serial/samsung.c                       |    4 +-
 drivers/tty/serial/serial_core.c                   |    6 +-
 drivers/tty/tty_ldisc.c                            |    2 +-
 drivers/tty/vt/vt_ioctl.c                          |   47 +++++++++++-----
 include/linux/serial_core.h                        |    3 +-
 9 files changed, 93 insertions(+), 38 deletions(-)

---------------

Alan Cox (1):
      pch_uart: Fix missing break for 16 byte fifo

Corbin (1):
      serial_core: Update buffer overrun statistics.

Darren Hart (1):
      pch_uart: Add eg20t_port lock field, avoid recursive spinlocks

Kyoungil Kim (1):
      serial: samsung: Fixed wrong comparison for baudclk_rate

Rabin Vincent (1):
      vt: fix race in vt_waitactive()

Roland Stigge (2):
      serial/8250: Add LPC3220 standard UART type
      serial/of-serial: Add LPC3220 standard UART compatible string

Shachar Shemesh (1):
      tty ldisc: Close/Reopen race prevention should check the proper flag

Tomoya MORINAGA (2):
      pch_uart: Fix rx error interrupt setting issue
      pch_uart: Fix parity setting issue

