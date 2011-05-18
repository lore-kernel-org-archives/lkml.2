Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab1EROor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 10:44:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757134Ab1EROoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 10:44:46 -0400
Date: Wed, 18 May 2011 16:44:29 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: NULL pointer deref in tty port / uart
Message-ID: <20110518144429.GC2011@jolsa.brq.redhat.com>
References: <20110517231229.GB1776@nowhere>
 <20110518004420.2b8f5da9@bob.linux.org.uk>
 <20110518142631.GB2011@jolsa.brq.redhat.com>
 <20110518153636.5cdcdd78@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518153636.5cdcdd78@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 03:36:36PM +0100, Alan Cox wrote:
> > have the same issue.. looks like we should not NULL the port->tty
> > if there's blocked open, but not sure what's exactly the logic
> > behind "port's block_open and count" ..
> 
> A pending open is not a user of the tty as far as the rest of the stack
> is concerned. I also don't see why clearing port->tty is causing this
> crash because nothing on that path should ever be going via port->tty and
> it isn't safe to do so.
> 
> > attached patch fixes it for me
> 
> But still breaks on hangup where we can't do that.
> 
> Where is port->tty getting misused to cause the crash, that is the bit
> I'm missing somewhere.

I think it's the 

uart_update_termios in uart_dtr_rts (drivers/tty/serial/serial_core.c)

called path:

tty_port_block_til_ready
	tty_port_raise_dtr_rts
		uart_dtr_rts
			uart_update_termios

jirka
