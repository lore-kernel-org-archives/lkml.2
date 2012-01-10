Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab2AJMDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 07:03:23 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41415 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2AJMDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 07:03:21 -0500
MIME-Version: 1.0
Date: Tue, 10 Jan 2012 20:03:21 +0800
Message-ID: <CABexPfGv=vkj5pq135+Jdy-E6fhppQK8Cq7FvuZV=tn8bA=SHw@mail.gmail.com>
Subject: [8259A] Why the irq_desc->handle_irq are set as handle_level_irq()
 while the ICW1 is set 0x11, which indicates edge mode?
From: Zhihua Che <zhihua.che@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, everyone

      I'm reading kernel codes of version 3.1x and now focusing on
interrupt subsystem. I find an interesting thing.
      In x86 architecture, init_8259A() is invoked by init_ISA_irqs()
to initialize the chip and precisely, the ICW1 of both master and
slave 8259A chip are set as 0x11 which indicates that the both chip
are enabled with edge trigger mode. However, I'm wondering why the
irq_desc->handle_irq fields of the total 16 IRQ descriptor are set as
handle_level_irq() in init_ISA_irqs(). As far as I know, the
handle_level_irq() is designed to handle level-mode interrupts.
      Please Let me know if I miss anything.

Harvey
