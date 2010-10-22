Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492Ab0JVSVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:21:33 -0400
Received: from kroah.org ([198.145.64.141]:41841 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab0JVSVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:21:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/49] serial: mfd: snprintf() returns largish values
Date: Fri, 22 Oct 2010 11:20:42 -0700
Message-Id: <1287771688-14805-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

snprintf() returns the number of bytes which would have been written so
it can be larger than the size of the buffer.  In this case it's fine,
but people copy and paste this code so I've fixed it.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/mfd.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/mfd.c b/drivers/serial/mfd.c
index 5dff45c..ad35130 100644
--- a/drivers/serial/mfd.c
+++ b/drivers/serial/mfd.c
@@ -172,6 +172,9 @@ static ssize_t port_show_regs(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, HSU_REGS_BUFSIZE - len,
 			"DIV: \t\t0x%08x\n", serial_in(up, UART_DIV));
 
+	if (len > HSU_REGS_BUFSIZE)
+		len = HSU_REGS_BUFSIZE;
+
 	ret =  simple_read_from_buffer(user_buf, count, ppos, buf, len);
 	kfree(buf);
 	return ret;
@@ -219,6 +222,9 @@ static ssize_t dma_show_regs(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, HSU_REGS_BUFSIZE - len,
 			"D0TSR: \t\t0x%08x\n", chan_readl(chan, HSU_CH_D3TSR));
 
+	if (len > HSU_REGS_BUFSIZE)
+		len = HSU_REGS_BUFSIZE;
+
 	ret =  simple_read_from_buffer(user_buf, count, ppos, buf, len);
 	kfree(buf);
 	return ret;
-- 
1.7.2

