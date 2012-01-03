Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab2ACQAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:00:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64705 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2ACQAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:00:49 -0500
Message-ID: <4F03262D.8090506@suse.cz>
Date: Tue, 03 Jan 2012 17:00:45 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20111223 Thunderbird/10.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: serial ports now asserting DTR and RTS during boot; breaks connected
 hardware
References: <20120103153707.GA12771@redhat.com>
In-Reply-To: <20120103153707.GA12771@redhat.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2012 04:37 PM, Dave Jones wrote:
> Jiri,
> We got this report from a user who notes a change in behaviour for
> his serial hardware over the last few kernel versions.

Hi!

I'm busy right now, however just after a quick look, it may be related to:
https://lkml.org/lkml/2011/12/6/573

I'll take a look later.

> https://bugzilla.redhat.com/show_bug.cgi?id=771010
> 
> This sounds like it might be related to your DTR/RTS changes back in March 2011 maybe ? 

What changes do you mean? In serial-core.c? That one is not used by USB
serials. Hence this wouldn't occur with FTDI.

>  > Description of problem:
>  > 
>  > After upgrade from FC14 to FC16, it was discovered that during kernel boot, the
>  > DTR and RTS signals of serial devices (both real UART and FTDI USB devices) are
>  > being asserted from driver load to approx 20 seconds afterward.  This causes
>  > some types of hardware connected to these ports to fail as they expect a
>  > different sequence or controlled activation of these signals.  In particular,
>  > ham radio equipment that uses these signals to key transmitters is now going
>  > into uncontrolled transmit for nearly the duration of kernel boot.
>  > 
>  > 
>  > Steps to Reproduce:
>  > 1. connect RS232 breakout box to serial port
>  > 2. boot system
>  > 3. watch DTR and RTS LEDs light as kernel is booting
>  > 
>  > Actual results:
>  > 
>  > LEDs light and stay light for almost entire boot duration indicating that DTR
>  > and RTS are asserting as the kernel boots.
>  > 
>  > Expected results:
>  > 
>  > DTR and RTS should not activate while kernel is booting.  They should only
>  > activate when the port is opened by an application and it has performed a
>  > termios function to enable these signals.
>  > 
>  > 
>  > Additional info:
>  > 
>  > The following code in the ftdi_sio driver is one suspect but this behavior
>  > happens on 8250 UARTs also so it is systemic now,
>  > 
>  > ftdi_sio.c, line 2161,
>  > 
>  >                 /* Ensure RTS and DTR are raised when baudrate changed from 0
>  > */
>  >                 if (!old_termios || (old_termios->c_cflag & CBAUD) == B0)
>  >                         set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
>  > 
> 
> 

regards,
-- 
js
suse labs
