Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab1DHNho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 09:37:44 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:55786 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752500Ab1DHNhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 09:37:43 -0400
Date: Fri, 8 Apr 2011 15:37:42 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Zaurus-devel] 2.6.39-rc2 on zaurus: does not build, does not
	boot
Message-ID: <20110408133742.GA21399@atrey.karlin.mff.cuni.cz>
References: <20110408062646.GA1472@ucw.cz> <20110408130715.GA1632@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408130715.GA1632@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > Boot stops just after mounting root filesystem; cursor stops
> > flashing. (Any idea what goes on there?)
> 
> With CF bluetooth unplugged, it gets  up to userland.
> 
> Once it hung in eaarly boot, once early in runlevel 2.

Hmm, the cf seems to be crippled a little.

I've got oops in pccard, but only when cf wifi is compiled in kernel and
inserted while booting, it stopped when the driver is compiled as module.

Note that zaurus has two cf slots, one for internal hd and one outside, so it
may be some race in cf/pccardd initalization.

Some parts of the trace:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] mpad=00000000
Internal error: Oops: f5 [#1] PREEMPT
las sysfs file:
CPU: 0 Not tainted (2.6.38....)
PC is at complete+0x30/0x90
LR is at giveback+0x134/0x150
pc: [<c0032070>]  lr : [<c019a4278>] psr: a0000093
sp : c38a4cb0  ip : c38atc70  fp : c38a5cc4

...

Flags: NzCv  IRQs off  FIQs on  Mode SYC_32  ISA ARM segment kernel
Control: 0000397f  Table a0004000  DAC: 00000017
Process: pccardd (pid 275, stack limit = 0xc38a4278)
Stack (0xc38a5cb0 to 0xc38a6000)
...

Which seems like problem occured in complete() ...

-- 
metan
