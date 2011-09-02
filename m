Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1IBMlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 08:41:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55080 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1IBMli convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 08:41:38 -0400
Subject: [PATCH -rt] printk: 'force_early_printk' boot param to help with
 debugging
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 02 Sep 2011 14:41:29 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314967289.1301.11.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: printk: 'force_early_printk' boot param to help with debugging
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Sep 02 14:29:33 CEST 2011

Gives me an option to screw printk and actually see what the machine
says.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-ykb97nsfmobq44xketrxs977@git.kernel.org
---
 kernel/printk.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -541,6 +541,13 @@ asmlinkage void early_printk(const char
  */
 static int __read_mostly printk_killswitch;
 
+static int __init force_early_printk_setup(char *str)
+{
+	printk_killswitch = 1;
+	return 0;
+}
+early_param("force_early_printk", force_early_printk_setup);
+
 void printk_kill(void)
 {
 	printk_killswitch = 1;

