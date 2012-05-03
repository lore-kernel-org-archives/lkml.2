Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab2ECMTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:19:43 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56720 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2ECMTl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:19:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120502212205.GA12212@kroah.com>
References: <20120502124642.30480.41373.sendpatchset@w520>
	<20120502124736.30480.48207.sendpatchset@w520>
	<4FA14788.6090000@windriver.com>
	<20120502212205.GA12212@kroah.com>
Date: Thu, 3 May 2012 21:19:40 +0900
Message-ID: <CANqRtoR7rtJW65jY3urnTcaS5S6swY84C-Xa8NMQkZP66m+==w@mail.gmail.com>
Subject: Re: [PATCH 06/06] serial8250-em: Add Emma Mobile UART driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-serial@vger.kernel.org, horms@verge.net.au, arnd@arndb.de,
        linux-sh@vger.kernel.org, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, lethal@linux-sh.org,
        olof@lixom.net, dan.j.williams@intel.com, alan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 6:22 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, May 02, 2012 at 10:41:12AM -0400, Paul Gortmaker wrote:
>> On 12-05-02 08:47 AM, Magnus Damm wrote:
>> > From: Magnus Damm <damm@opensource.se>
>> >
>> > Add a platform driver for Emma Mobile 8250 hardware.
>>
>>
>> [...]
>>
>> > +
>> > +config SERIAL_8250_EM
>> > +   tristate "Support for Emma Mobile intergrated serial port"
>> > +   depends on SERIAL_8250
>>
>> Should we depend on arch=ARM or something similar?  Even if the
>> driver is written to be arch independent, if the Emma itself is
>> physically tied to ARM platforms, we probably don't need to be
>> building it for sparc allyesconfig etc.
>
> Yeah, it doesn't build on x86-64, I get the following build problems:
>        ERROR: "clk_get_rate" [drivers/tty/serial/8250/8250_em.ko] undefined!
>        ERROR: "clk_enable" [drivers/tty/serial/8250/8250_em.ko] undefined!
>        ERROR: "clk_get" [drivers/tty/serial/8250/8250_em.ko] undefined!
>        ERROR: "clk_put" [drivers/tty/serial/8250/8250_em.ko] undefined!
>        ERROR: "clk_disable" [drivers/tty/serial/8250/8250_em.ko] undefined!
>
> So it should depend on some arch that has clk at the least.
>
> Magnus, care to redo just this one patch that fixes this up?  I've
> applied the first 5 already.

Done!

I decided to go with SERIAL_8250 && ARM && HAVE_CLK to limit the
exposure a bit but not hinder any single ARM kernel image work. Hope
this balance is making everyone happy.

It is not impossible that this driver can be used on older MIPS based
SoCs from NEC, but that can easily be dealt with later if needed.

Thanks for your help!

/ magnus
