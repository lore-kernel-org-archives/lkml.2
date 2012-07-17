Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2GQRhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:37:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390Ab2GQRg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:36:57 -0400
Date: Tue, 17 Jul 2012 13:36:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] kdump: Append newline to the last lien of vmcoreinfo note
Message-ID: <20120717173655.GC11031@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last line of vmcoreinfo note does not end with \n. Parsing all the lines
in note becomes easier if all lines end with \n instead of trying to special
case the last line.

I know atleast one tool, vmcore-dmesg in kexec-tools tree which made the
assumption that all lines end with \n. I think it is a good idea to
fix it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 kernel/kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c	2012-07-17 19:26:38.844033784 -0400
+++ linux-2.6/kernel/kexec.c	2012-07-17 23:51:33.311701781 -0400
@@ -1424,7 +1424,7 @@ static void update_vmcoreinfo_note(void)
 
 void crash_save_vmcoreinfo(void)
 {
-	vmcoreinfo_append_str("CRASHTIME=%ld", get_seconds());
+	vmcoreinfo_append_str("CRASHTIME=%ld\n", get_seconds());
 	update_vmcoreinfo_note();
 }
 
