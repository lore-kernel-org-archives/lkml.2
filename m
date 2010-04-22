Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0DVNKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:10:11 -0400
Received: from mx1.corp.avencall.com ([91.194.178.12]:59983 "EHLO
	mx1.corp.avencall.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab0DVNKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:10:09 -0400
From: Guillaume Knispel <gknispel@proformatique.com>
To: linux-kernel@vger.kernel.org, Linuxppc-dev@lists.ozlabs.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>, Peter Zijlstra <peterz@infradead.org>,
       Russell King <linux@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Guillaume Knispel <gknispel@proformatique.com>
Subject: [PATCH 0/2] genirq: reliably replay pending edge-triggered irq (plus doc)
Date: Thu, 22 Apr 2010 15:09:56 +0200
Message-Id: <1271941798-9659-1-git-send-email-gknispel@proformatique.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the following series:


[1/2] implements the proposal I made at the end of the thread
http://lkml.org/lkml/2010/4/19/129 to reliably support replay
of edge-triggered interrupts on all architectures when using
disable_irq() / enable_irq().

Proper replays of pending edge-triggered interrupts was
depending on CONFIG_HARDIRQS_SW_RESEND which only seems to have
been noticed for plateforms of ARM and AVR32 architecture while
it should also have been used on other architectures to get the
correct behavior. So the patch removes CONFIG_HARDIRQS_SW_RESEND
and unconditionally builds the resend_irqs() tasklet and its
scheduling.

I only tested an equivalent patch for linux-2.6.22.18 on powerpc
for a board with an MPC8555E (using a portC line on the CPM2 PIC),
and build-tested this one for x86.


[2/2] updates Documentation/DocBook/genericirq.tmpl, taking
into account 1/2 other previous undocumented changes to genirq.


--
Guillaume Knispel
