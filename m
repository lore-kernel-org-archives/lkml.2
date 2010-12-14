Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab0LNKFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:05:51 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47267 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0LNKFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:05:50 -0500
Date: Tue, 14 Dec 2010 15:35:54 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch 7/21] Define API for reading arch specif Program Headers for
 Core
Message-ID: <20101214153554.75d1698c@suzukikp>
In-Reply-To: <20101214152259.67896960@suzukikp>
References: <20101214152259.67896960@suzukikp>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The binfmt ELF defines APIs for the "arch" specific Program headers to be 
written to the ELF core. Define the "read" (or copy) variants of the APIs, to 
collect it for the application core dump(which is a read based approach).

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 include/linux/elfcore.h |    3 +++
 kernel/elfcore.c        |    6 ++++++
 2 files changed, 9 insertions(+)

Index: linux-2.6.36-rc7/include/linux/elfcore.h
===================================================================
--- linux-2.6.36-rc7.orig/include/linux/elfcore.h
+++ linux-2.6.36-rc7/include/linux/elfcore.h
@@ -163,6 +163,9 @@ extern int
 elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
 			   unsigned long limit);
 extern int
+elf_core_copy_extra_phdrs(char *buf, loff_t offset, size_t *size,
+			   unsigned long limit);
+extern int
 elf_core_write_extra_data(struct file *file, size_t *size, unsigned long limit);
 extern size_t elf_core_extra_data_size(void);
 
Index: linux-2.6.36-rc7/kernel/elfcore.c
===================================================================
--- linux-2.6.36-rc7.orig/kernel/elfcore.c
+++ linux-2.6.36-rc7/kernel/elfcore.c
@@ -16,6 +16,12 @@ int __weak elf_core_write_extra_phdrs(st
 	return 1;
 }
 
+int __weak elf_core_copy_extra_phdrs(char *buf, loff_t offset, size_t *size,
+					unsigned long limit)
+{
+	return 1;
+}
+
 int __weak elf_core_write_extra_data(struct file *file, size_t *size,
 				     unsigned long limit)
 {
