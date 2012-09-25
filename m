Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2IYJSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:18:46 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:50302 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab2IYJSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:18:45 -0400
Date: Tue, 25 Sep 2012 11:18:26 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 5/6] ARM: dove: Remove watchdog from DT
Message-ID: <20120925111826.6f4086ee@skate>
In-Reply-To: <5061754E.9050204@gmail.com>
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1348531338-16624-6-git-send-email-sebastian.hesselbarth@gmail.com>
	<20120925053542.GK14266@lunn.ch>
	<5061754E.9050204@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Tue, 25 Sep 2012 11:11:42 +0200, Sebastian Hesselbarth wrote:

> I didn't try to post all the dove on mach-mvebu patches in the current
> release cycle, because mach-mvebu is still evolving to fast for me to keep
> up with my limited spare time. But I have dove running on mach-mvebu...

Yes, this work is really great. However, I think that instead of making
a big change at once, we should rather follow something like:

 * Make mach-dove, mach-kirkwood, mach-orion5x, mach-mv78xx0 use the
   new gpio/pinctrl code

 * Remove the plat-orion gpio/pinctrl code

 * Make mach-dove, mach-kirkwood, mach-orion5x, mach-mv78xx0 use DT for
   everything.

 * Remove the plat-orion common.c file (once all devices are probed
   through DT, common.c is no longer needed).

 * Add clock framework support for everybody, with the code in
   drivers/clk/.

 * Refactor the PCI code so that it can cover all cases. We should soon
   be working on PCI support on Armada 370/XP, so it will show what are
   the differences/issues in having something that covers all cases.

 * And then, only, merge everybody in mach-mvebu.

The idea here is to make the existing
mach-{dove,kirkwood,orion5x,mv78xx0} gradually converge to DT,
pinctrl/gpio, clock and other things, and only after that merge into
mach-mvebu. It will be much easier to do the merge as most of the code
in those mach- directory will have disappeared, as well as the code in
plat-orion.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
