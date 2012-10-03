Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2JCLs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:48:58 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33651 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab2JCLs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:48:56 -0400
MIME-Version: 1.0
Date: Wed, 3 Oct 2012 17:18:56 +0530
Message-ID: <CAGr+u+yxC3nPrsW+EU9qwh0ggjqrg9K=1ftQXfds8unMiDMZsA@mail.gmail.com>
Subject: DEBUG_STACKOVERFLOW issue on ARM
From: trisha yad <trisha1march@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,
In kernel 3.0.X we find "Check for stackoverflow"
(CONFIG_DEBUG_STACKOVERFLOW) implementation for following
architecture:
frv, mn10300, m32r, tile, x86, mips, powerpc, blackfin except ARM.

Therefore we implemented the similar functionality for ARM in asm_do_IRQ();
We have tested it using a test module.ko that allocate memory on kernel stack.

This test code work fine on single core, but fail to detect stack
overflow in multi-core ARM. While debugging we found that
interrupts were occurring only in CPU0, while the test module was
running in CPU1, since the kernel stack of CPU0 is unaffected
by CPU1 kernel stack, it fails to detect the problem.

However when I upgraded the kernel from 3.0 to 3.4, the stack overflow
detection started working.

I wish to know how can I support this function in 3.0 ?

Regards
