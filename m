Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab0G0DRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 23:17:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36631 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab0G0DRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 23:17:46 -0400
Date: Tue, 27 Jul 2010 13:17:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonas Bonn <jonas@southpole.se>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Michal Simek <michal.simek@petalogix.com>
Subject: linux-next: manual merge of the devicetree tree with the microblaze
 tree
Message-Id: <20100727131740.38ea876e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
arch/microblaze/kernel/Makefile between commit
117aa948321f3b019d9d8160591dc8256a6035cd ("microblaze: Add stack
unwinder") from the microblaze tree and commit
c0dd394ca5e78649b7013c3ce2d6338af9f228f0 ("of: remove
of_default_bus_ids") from the devicetree tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/microblaze/kernel/Makefile
index d66ddef,7fcc5f7..0000000
--- a/arch/microblaze/kernel/Makefile
+++ b/arch/microblaze/kernel/Makefile
@@@ -15,9 -15,9 +15,9 @@@ endi
  extra-y := head.o vmlinux.lds
  
  obj-y += dma.o exceptions.o \
- 	hw_exception_handler.o init_task.o intc.o irq.o of_device.o \
- 	of_platform.o process.o prom.o prom_parse.o ptrace.o \
+ 	hw_exception_handler.o init_task.o intc.o irq.o \
+ 	process.o prom.o prom_parse.o ptrace.o \
 -	setup.o signal.o sys_microblaze.o timer.o traps.o reset.o
 +	reset.o setup.o signal.o sys_microblaze.o timer.o traps.o unwind.o
  
  obj-y += cpu/
  
