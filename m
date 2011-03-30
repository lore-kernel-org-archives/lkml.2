Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab1C3C7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:59:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:3125 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab1C3C7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:59:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,266,1299484800"; 
   d="scan'208";a="673079163"
Subject: [tip:ia64/urgent] Fix sn_force_interrupt_flag no defination issue
From: "Alex,Shi" <alex.shi@intel.com>
To: tony.luck@intel.com, tglx@linutronix.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>, "Shi, Alex" <alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 11:01:29 +0800
Message-ID: <1301454089.15889.170.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sn_force_interrupt_flag was removed in 39-rc1 patch. But it still be
used in arch/ia64/sn/kernel/sn2/sn_proc_fs.c. that make compilation
failed: 
arch/ia64/sn/built-in.o: In function `sn_force_interrupt_show':
sn_proc_fs.c:(.text+0xd281): undefined reference to `sn_force_interrupt_flag'
sn_proc_fs.c:(.text+0xd2a0): undefined reference to `sn_force_interrupt_flag'
A quick fix for this.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/ia64/sn/kernel/sn2/sn_proc_fs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/sn/kernel/sn2/sn_proc_fs.c b/arch/ia64/sn/kernel/sn2/sn_proc_fs.c
index c76d8dc..ce3215d 100644
--- a/arch/ia64/sn/kernel/sn2/sn_proc_fs.c
+++ b/arch/ia64/sn/kernel/sn2/sn_proc_fs.c
@@ -51,7 +51,7 @@ static int licenseID_open(struct inode *inode, struct file *file)
  * the bridge chip.  The hardware will then send an interrupt message if the
  * interrupt line is active.  This mimics a level sensitive interrupt.
  */
-extern int sn_force_interrupt_flag;
+int sn_force_interrupt_flag;
 
 static int sn_force_interrupt_show(struct seq_file *s, void *p)
 {


