Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372Ab2CMJqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:46:38 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49253 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760287Ab2CMJqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:46:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6647"; a="171955174"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv2 2/3] coccinelle: semantic patch for simple_open()
Date: Tue, 13 Mar 2012 02:46:27 -0700
Message-Id: <1331631988-20527-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1331631988-20527-1-git-send-email-sboyd@codeaurora.org>
References: <1331631988-20527-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find instances of an open-coded simple_open() and replace them
with calls to simple_open().

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

Julia,

I couldn't figure out the report mode so please feel free to
add it.

 Changes since v1: Add depends on patch

 scripts/coccinelle/api/simple_open.cocci |   34 ++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 scripts/coccinelle/api/simple_open.cocci

diff --git a/scripts/coccinelle/api/simple_open.cocci b/scripts/coccinelle/api/simple_open.cocci
new file mode 100644
index 0000000..87c6285
--- /dev/null
+++ b/scripts/coccinelle/api/simple_open.cocci
@@ -0,0 +1,34 @@
+// This removes an open coded simple_open() function
+// and replaces file operations references to the function
+// with simple_open() instead.
+//
+
+virtual patch
+virtual context
+
+@ open depends on patch @
+identifier open_f != simple_open;
+identifier i, f;
+@@
+-int open_f(struct inode *i, struct file *f)
+-{
+(
+-if (i->i_private)
+-f->private_data = i->i_private;
+|
+-f->private_data = i->i_private;
+)
+-return 0;
+-}
+
+@ has_open depends on open @
+identifier fops;
+identifier open.open_f;
+@@
+struct file_operations fops = {
+...
+-.open = open_f,
++.open = simple_open,
+...
+};
+
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

