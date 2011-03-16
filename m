Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab1CPAWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 20:22:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33237 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab1CPAWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 20:22:35 -0400
Date: Tue, 15 Mar 2011 17:22:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH -next] uml: fix tty interface warnings
Message-Id: <20110315172208.82934b13.randy.dunlap@oracle.com>
In-Reply-To: <20110315194543.a5d56c0c.sfr@canb.auug.org.au>
References: <20110315194543.a5d56c0c.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D8002B5.001D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix tty interface warnings in arch/um:

arch/um/drivers/stdio_console.c:122: warning: initialization from incompatible pointer type
arch/um/drivers/ssl.c:139: warning: initialization from incompatible pointer type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Jeff Dike <jdike@addtoit.com>
Cc:	user-mode-linux-devel@lists.sourceforge.net
---
 arch/um/drivers/line.c        |    3 +--
 arch/um/include/shared/line.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- linux-next-20110315.orig/arch/um/drivers/line.c
+++ linux-next-20110315/arch/um/drivers/line.c
@@ -255,8 +255,7 @@ static const struct {
 	{ KDSIGACCEPT, KERN_INFO,  "KDSIGACCEPT" },
 };
 
-int line_ioctl(struct tty_struct *tty, struct file * file,
-	       unsigned int cmd, unsigned long arg)
+int line_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 {
 	int ret;
 	int i;
--- linux-next-20110315.orig/arch/um/include/shared/line.h
+++ linux-next-20110315/arch/um/include/shared/line.h
@@ -77,7 +77,7 @@ extern int line_chars_in_buffer(struct t
 extern void line_flush_buffer(struct tty_struct *tty);
 extern void line_flush_chars(struct tty_struct *tty);
 extern int line_write_room(struct tty_struct *tty);
-extern int line_ioctl(struct tty_struct *tty, struct file * file,
+extern int line_ioctl(struct tty_struct *tty,
 		      unsigned int cmd, unsigned long arg);
 extern void line_throttle(struct tty_struct *tty);
 extern void line_unthrottle(struct tty_struct *tty);
