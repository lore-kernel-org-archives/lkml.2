Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204Ab2KPFHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 00:07:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:33697 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab2KPFHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 00:07:19 -0500
Date: Thu, 15 Nov 2012 21:08:07 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, hjchoi <hjchoi@sysbas.com>
Subject: Re: [PATCH] staging: Add SystemBase Multi-2/PCI driver
Message-ID: <20121116050807.GA13122@kroah.com>
References: <1353040771.7586.2.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1353040771.7586.2.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 11:39:31PM -0500, Steven Rostedt wrote:
> I ported the driver supplied by SystemBase to mainline.
> 
> As the driver had MODULE_LICENSE("GPL") it is declared as a GPL module
> and thus I have the right to distribute it upstream. Note, I did the
> bare minimum to get it working. It still needs a lot of loving.

Being in staging only requires 2 things, proper license, and it has to
build.

This fails on the second one:

In file included from drivers/staging/sb105x/sb_pci_mp.c:1:0:
drivers/staging/sb105x/sb_pci_mp.h:279:40: error: array type has incomplete element type
drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_startup’:
drivers/staging/sb105x/sb_pci_mp.c:546:26: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_shutdown’:
drivers/staging/sb105x/sb_pci_mp.c:573:40: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_change_speed’:
drivers/staging/sb105x/sb_pci_mp.c:596:14: error: wrong type argument to unary exclamation mark
drivers/staging/sb105x/sb_pci_mp.c:599:10: error: incompatible types when assigning to type ‘struct ktermios *’ from type ‘struct ktermios’
drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_throttle’:
drivers/staging/sb105x/sb_pci_mp.c:734:18: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_unthrottle’:
drivers/staging/sb105x/sb_pci_mp.c:750:18: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_set_termios’:
drivers/staging/sb105x/sb_pci_mp.c:1277:35: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
drivers/staging/sb105x/sb_pci_mp.c:1282:4: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_update_termios’:
drivers/staging/sb105x/sb_pci_mp.c:1450:19: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
drivers/staging/sb105x/sb_pci_mp.c: In function ‘mp_block_til_ready’:
drivers/staging/sb105x/sb_pci_mp.c:1476:24: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
drivers/staging/sb105x/sb_pci_mp.c:1481:25: error: invalid type argument of ‘->’ (have ‘struct ktermios’)
drivers/staging/sb105x/sb_pci_mp.c: In function ‘multi_type’:
drivers/staging/sb105x/sb_pci_mp.c:2763:14: error: bit-field ‘<anonymous>’ width not an integer constant
In file included from drivers/staging/sb105x/sb_pci_mp.c:1:0:
drivers/staging/sb105x/sb_pci_mp.c: At top level:
drivers/staging/sb105x/sb_pci_mp.h:279:40: warning: ‘uart_config’ defined but not used [-Wunused-variable]
drivers/staging/sb105x/sb_pci_mp.c: In function ‘multi_type’:
drivers/staging/sb105x/sb_pci_mp.c:2766:1: warning: control reaches end of non-void function [-Wreturn-type]
make[3]: *** [drivers/staging/sb105x/sb_pci_mp.o] Error 1
make[2]: *** [drivers/staging/sb105x] Error 2
make[1]: *** [drivers/staging] Error 2

Care to redo this against my staging-next tree, or, even better,
linux-next, which contains a bunch of tty changes in it?

Or, if you want, I can take a whack at it to get it to build properly,
whichever is easier for you.

thanks,

greg k-h
