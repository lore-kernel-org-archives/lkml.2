Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab1KRWxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:53:45 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:63335 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab1KRWxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:53:44 -0500
Date: Fri, 18 Nov 2011 23:53:29 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: greg@kroah.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        balbi@ti.com, broonie@opensource.wolfsonmicro.com
Subject: [PATCH] debugfs: print_regs32: make regs array a const pointer
Message-ID: <20111118225329.GA5737@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20111118194843.GA17915@kroah.com>
References: <20111118194843.GA17915@kroah.com>
  <20111118002049.GA24806@mail.gnudd.com>
  <20111118135143.GA1101@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
---
 fs/debugfs/file.c       |    2 +-
 include/linux/debugfs.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index f31a27c..fc98ec9 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -548,7 +548,7 @@ EXPORT_SYMBOL_GPL(debugfs_create_blob);
  * because some peripherals have several blocks of identical registers,
  * for example configuration of dma channels
  */
-int debugfs_print_regs32(struct seq_file *s, struct debugfs_reg32 *regs,
+int debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
 			   int nregs, void __iomem *base, char *prefix)
 {
 	int i, ret = 0;
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 5e6b01f..e8c3abc 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -90,7 +90,7 @@ struct dentry *debugfs_create_regset32(const char *name, mode_t mode,
 				     struct dentry *parent,
 				     struct debugfs_regset32 *regset);
 
-int debugfs_print_regs32(struct seq_file *s, struct debugfs_reg32 *regs,
+int debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
 			 int nregs, void __iomem *base, char *prefix);
 
 bool debugfs_initialized(void);
-- 
1.5.6.5
