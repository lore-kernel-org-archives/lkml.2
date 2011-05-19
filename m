Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1ESLTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:19:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab1ESLTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:19:19 -0400
Date: Thu, 19 May 2011 13:19:01 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: NULL pointer deref in tty port / uart
Message-ID: <20110519111901.GC2061@jolsa.brq.redhat.com>
References: <20110517231229.GB1776@nowhere>
 <20110518004420.2b8f5da9@bob.linux.org.uk>
 <20110518142631.GB2011@jolsa.brq.redhat.com>
 <20110518153636.5cdcdd78@lxorguk.ukuu.org.uk>
 <20110518144429.GC2011@jolsa.brq.redhat.com>
 <20110518155033.2773b323@bob.linux.org.uk>
 <20110518194212.GA27758@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518194212.GA27758@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 12:42:12PM -0700, Greg KH wrote:
> On Wed, May 18, 2011 at 03:50:33PM +0100, Alan Cox wrote:
> > > I think it's the 
> > > 
> > > uart_update_termios in uart_dtr_rts (drivers/tty/serial/serial_core.c)
> > > 
> > > called path:
> > > 
> > > tty_port_block_til_ready
> > > 	tty_port_raise_dtr_rts
> > > 		uart_dtr_rts
> > > 			uart_update_termios
> > 
> > Ah that would explain why I can't find and dup it - it isn't found in
> > the current -next tree.
> > 
> > 
> > c7d7abff40c27f82fe78b1091ab3fad69b2546f9 (and thereafter)
> > 
> > Jiri Slaby fixed it in sorting out uart_startup
> > 
> > I guess these should now get tagged for -stable.
> 
> So that would be the following patches in the linux-next tree:
> 	c7d7abff40c27f82fe78b1091ab3fad69b2546f9 serial: core, move termios handling to uart_startup
> 	303a7a1199c20f7c9452f024a6e17bf348b6b398 serial: core, do not set DTR/RTS twice on startup
> 	6f5c24ad0f7619502199185a026a228174a27e68 serial: core, remove uart_update_termios
> 
> right?
> 
> Anything else need to be backported?
> 
> Frederic, can you test that these 3 patches solve the problem for you?
> If you want, I can send them to you separately if you don't have a copy
> of linux-next around anywhere.
> 
> thanks,
> 
> greg k-h

I tried linux-next and cannot hit the issue anymore

thanks,
jirka
