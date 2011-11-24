Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1KXHWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 02:22:45 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:55547 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1KXHWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 02:22:44 -0500
Date: Thu, 24 Nov 2011 10:22:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] debugfs: remove unneeded cast in debugfs_print_regs32()
Message-ID: <20111124072207.GD14122@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4ECDF0B9.00A6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cast here causes a Sparse warning:
fs/debugfs/file.c:561:42: warning: cast removes address space of expression
fs/debugfs/file.c:561:42: warning: incorrect type in argument 1 (different address spaces)
fs/debugfs/file.c:561:42:    expected void const volatile [noderef] <asn:2>*addr
fs/debugfs/file.c:561:42:    got void *<noident>

It's redundant to cast it to a (void *) anyway when it is already a
(void __iomem *).

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index e0a3a59..989f07f 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -558,7 +558,7 @@ int debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
 		if (prefix)
 			ret += seq_printf(s, "%s", prefix);
 		ret += seq_printf(s, "%s = 0x%08x\n", regs->name,
-				  readl((void *)(base + regs->offset)));
+				  readl(base + regs->offset));
 	}
 	return ret;
 }
