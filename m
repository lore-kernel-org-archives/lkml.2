Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab0LNKDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:03:11 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:53712 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0LNKDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:03:09 -0500
Date: Tue, 14 Dec 2010 15:33:14 +0530
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
Subject: [Patch 5/21] Rename compat versions of the reusable core generation
 routines
Message-ID: <20101214153314.04d05dd2@suzukikp>
In-Reply-To: <20101214152259.67896960@suzukikp>
References: <20101214152259.67896960@suzukikp>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the ELF class specific functions reusable for the application core dump 
infrastructure. The compat ELF class routines are prepended with compat_ .

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/compat_binfmt_elf.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.36-rc7/fs/compat_binfmt_elf.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/compat_binfmt_elf.c
+++ linux-2.6.36-rc7/fs/compat_binfmt_elf.c
@@ -127,6 +127,13 @@ static void cputime_to_compat_timeval(co
 #define init_elf_binfmt		init_compat_elf_binfmt
 #define exit_elf_binfmt		exit_compat_elf_binfmt
 
+/* Rename the functions that may be reused */
+#define fill_elf_header 	compat_fill_elf_header
+#define fill_psinfo		compat_fill_psinfo
+#define fill_prstatus		compat_fill_prstatus
+#define fill_extnum_info	compat_fill_extnum_info
+#define fill_auxv_note		compat_fill_auxv_note
+
 /*
  * We share all the actual code with the native (64-bit) version.
  */
