Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab2KPNR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 08:17:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22069 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab2KPNR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:17:57 -0500
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=cPT-bUsLaBUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=eJptcAyAPSAA:10 a=d0IoTAm37rc9U5oPpCAA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1353071875.7586.5.camel@gandalf.local.home>
Subject: Re: [PATCH] staging: Add SystemBase Multi-2/PCI driver
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, hjchoi <hjchoi@sysbas.com>
Date: Fri, 16 Nov 2012 08:17:55 -0500
In-Reply-To: <20121116050807.GA13122@kroah.com>
References: <1353040771.7586.2.camel@gandalf.local.home>
	 <20121116050807.GA13122@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-15 at 21:08 -0800, Greg Kroah-Hartman wrote:
> On Thu, Nov 15, 2012 at 11:39:31PM -0500, Steven Rostedt wrote:
> > I ported the driver supplied by SystemBase to mainline.
> > 
> > As the driver had MODULE_LICENSE("GPL") it is declared as a GPL module
> > and thus I have the right to distribute it upstream. Note, I did the
> > bare minimum to get it working. It still needs a lot of loving.
> 
> Being in staging only requires 2 things, proper license, and it has to
> build.
> 
> This fails on the second one:
> 
> In file included from drivers/staging/sb105x/sb_pci_mp.c:1:0:
> drivers/staging/sb105x/sb_pci_mp.h:279:40: error: array type has incomplete element type
> drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_startup’:
> drivers/staging/sb105x/sb_pci_mp.c:546:26: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
> drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_shutdown’:
> drivers/staging/sb105x/sb_pci_mp.c:573:40: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
> drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_change_speed’:
> drivers/staging/sb105x/sb_pci_mp.c:596:14: error: wrong type argument to unary exclamation mark
> drivers/staging/sb105x/sb_pci_mp.c:599:10: error: incompatible types when assigning to type ‘struct ktermios *’ from type ‘struct ktermios’
> drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_throttle’:
> drivers/staging/sb105x/sb_pci_mp.c:734:18: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
> drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_unthrottle’:
> drivers/staging/sb105x/sb_pci_mp.c:750:18: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
> drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_set_termios’:
> drivers/staging/sb105x/sb_pci_mp.c:1277:35: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
> drivers/staging/sb105x/sb_pci_mp.c:1282:4: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
> drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_update_termios’:
> drivers/staging/sb105x/sb_pci_mp.c:1450:19: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
> drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_block_til_ready’:
> drivers/staging/sb105x/sb_pci_mp.c:1476:24: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
> drivers/staging/sb105x/sb_pci_mp.c:1481:25: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
> drivers/staging/sb105x/sb_pci_mp.c: In function ‘multi_type’:
> drivers/staging/sb105x/sb_pci_mp.c:2763:14: error: bit-field ‘<anonymous>’ width not an integer constant
> In file included from drivers/staging/sb105x/sb_pci_mp.c:1:0:
> drivers/staging/sb105x/sb_pci_mp.c: At top level:
> drivers/staging/sb105x/sb_pci_mp.h:279:40: warning: ‘uart_config’ defined but not used [-Wunused-variable]
> drivers/staging/sb105x/sb_pci_mp.c: In function ‘multi_type’:
> drivers/staging/sb105x/sb_pci_mp.c:2766:1: warning: control reaches end of non-void function [-Wreturn-type]
> make[3]: *** [drivers/staging/sb105x/sb_pci_mp.o] Error 1
> make[2]: *** [drivers/staging/sb105x] Error 2
> make[1]: *** [drivers/staging] Error 2

Ah interesting, probably a missing dependency. Do you have a config I
can test against. It worked for me against 3.6.6 (the kernel that runs
the box with the card).

> 
> Care to redo this against my staging-next tree, or, even better,
> linux-next, which contains a bunch of tty changes in it?

Sure, and I may try it against a few randconfigs (but forcing this
driver enabled, as ktest allows for that ;-)

> 
> Or, if you want, I can take a whack at it to get it to build properly,
> whichever is easier for you.

Of course it would be easier for me to have you do it :-)  But you
already have enough on your plate. I'll get it done, as I may be the
only person using this card.

-- Steve


