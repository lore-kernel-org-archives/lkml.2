Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab2ECLDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:03:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49392 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab2ECLDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:03:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 06/06] serial8250-em: Add Emma Mobile UART driver
Date: Thu, 3 May 2012 08:46:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-serial@vger.kernel.org,
        horms@verge.net.au, linux-sh@vger.kernel.org, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, lethal@linux-sh.org,
        olof@lixom.net, dan.j.williams@intel.com, alan@linux.intel.com
References: <20120502124642.30480.41373.sendpatchset@w520> <4FA14788.6090000@windriver.com> <20120502212205.GA12212@kroah.com>
In-Reply-To: <20120502212205.GA12212@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205030846.55250.arnd@arndb.de>
X-Provags-ID: V02:K0:LeKfvF4FZCrKpi8xWt6/MQh0jbvk8Fn62B2N1sz9X4V
 UZqftIrF+I9E2tl5lZWrS2oDCLHQqCO13bXyccFhPWKhephdvB
 9KZDBGj4H/EBtmlvaEF+EvfJGnA1qqgZ0r163dXCMc08biuKTI
 InmqN8ffJQOzCMkK51oMPk9RMZlBQeSb94L6tk832CbPE7f23n
 eUHW95sA6nC4vf99jczZlUdIEQeY7HHAozJ8nt4yQXb3whxLxu
 1t6uGRsI19T1Flw2TBbK6bClYEY781NQL+R+0aBFg1ghneLSwd
 6jYd5klC4aTg/pV/WBSn2A9f6CCIhAJmxE8JNxAzpnIM6uudGd
 oMYIZkeM+q/md601pP88=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2012, Greg KH wrote:
> > > +
> > > +config SERIAL_8250_EM
> > > +   tristate "Support for Emma Mobile intergrated serial port"
> > > +   depends on SERIAL_8250
> > 
> > Should we depend on arch=ARM or something similar?  Even if the
> > driver is written to be arch independent, if the Emma itself is
> > physically tied to ARM platforms, we probably don't need to be
> > building it for sparc allyesconfig etc.
> 
> Yeah, it doesn't build on x86-64, I get the following build problems:
>         ERROR: "clk_get_rate" [drivers/tty/serial/8250/8250_em.ko] undefined!
>         ERROR: "clk_enable" [drivers/tty/serial/8250/8250_em.ko] undefined!
>         ERROR: "clk_get" [drivers/tty/serial/8250/8250_em.ko] undefined!
>         ERROR: "clk_put" [drivers/tty/serial/8250/8250_em.ko] undefined!
>         ERROR: "clk_disable" [drivers/tty/serial/8250/8250_em.ko] undefined!
> 
> So it should depend on some arch that has clk at the least.
> 
> Magnus, care to redo just this one patch that fixes this up?  I've
> applied the first 5 already.

I think it's best to make it depend on HAVE_CLK, but depending on
ARM && HAVE_CLK is also fine with me. I would not like to have it depend
on EMMA specifically though because I want to increase built coverage.

	Arnd

