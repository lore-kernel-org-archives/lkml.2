Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0DRDn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 23:43:59 -0400
Received: from mx1.corp.avencall.com ([91.194.178.12]:57701 "EHLO
	mx1.corp.avencall.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab0DRDn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 23:43:58 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Apr 2010 23:43:58 EDT
Date: Sun, 18 Apr 2010 05:34:39 +0200
From: Guillaume Knispel <gknispel@proformatique.com>
To: linux-kernel@vger.kernel.org, Linuxppc-dev@lists.ozlabs.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Lars-Peter Clausen <lars@metafoo.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Pending interrupts not always replayed
Message-ID: <20100418053439.4d2ffe11@xilun.lan.proformatique.com>
Organization: Proformatique
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>From reading the code (kernel/irq stuffs), it seems that at least some
handle_edge_irq based interrupts are not replayed when enabling if
desc->chip->retrigger == NULL and on a platform where
CONFIG_HARDIRQS_SW_RESEND is not set (which for now is only defined for
(some?) arm and avr32). Depending on the pic this problem might
be masked if multiple interrupts are received between disable_irq and
enable_irq (maybe other conditions exist with controllers i don't know).

I happen to program a PPC SoC (MPC8555E to be precise), using some edge
interrupts on the PortC of the CPM2 pic (arch/powerpc/sysdev/cpm2_pic.c)
in a driver that does some enable_irq/disable_irq while various
patterns of interrupts are received and i think i've hit the problem.

Is the behavior intended (not always replaying edge triggered interrupts)
or is it just a bug to fix?

Anybody knows if it's safe to activate CONFIG_HARDIRQS_SW_RESEND for a
powerpc or are there some known dangerous interactions?
(I'll give it a try on my side in the meantime anyway)

Cheers!
-- 
Guillaume Knispel
