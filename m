Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab0EDATu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 20:19:50 -0400
Received: from mx1.corp.avencall.com ([91.194.178.12]:51393 "EHLO
	mx1.corp.avencall.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab0EDATt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 20:19:49 -0400
Date: Tue, 4 May 2010 02:19:41 +0200
From: Guillaume Knispel <gknispel@proformatique.com>
To: linux-kernel@vger.kernel.org, Linuxppc-dev@lists.ozlabs.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Guillaume Knispel <gknispel@proformatique.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Russell King <linux@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv2 0/2] genirq: reliably replay pending edge-triggered irq
 (plus doc)
Message-Id: <20100504021941.ff7579c1.gknispel@proformatique.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
correct behavior. So the patch unconditionally builds the
resend_irqs() tasklet and its scheduling
(CONFIG_HARDIRQS_SW_RESEND is not used anymore).

I only tested an equivalent patch for linux-2.6.22.18 on powerpc
for a board with an MPC8555E (using a portC line on the CPM2 PIC),
and build-tested this one for x86.


[2/2] updates Documentation/DocBook/genericirq.tmpl, taking
into account 1/2 other previous undocumented changes to genirq.


History:
[v2]	- Don't touch archs Kconfig and defconfigs
	  (CONFIG_HARDIRQS_SW_RESEND is left unused)
	- Don't make unrelated change to a comment in
	  arch/x86/kernel/apic/io_apic.c
	- (hopefully) Better commit message for [1/2]
	- Correct spelling errors in [2/2]

[v1]	- initial patch


Guillaume Knispel (2):
  genirq: reliably replay pending edge-triggered irq
  genirq: update doc

 Documentation/DocBook/genericirq.tmpl |   73 ++++++++++++++++++--------------
 kernel/irq/resend.c                   |    6 ---
 2 files changed, 41 insertions(+), 38 deletions(-)
