Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1KYIRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 03:17:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab1KYIRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 03:17:52 -0500
Date: Fri, 25 Nov 2011 16:19:59 +0800
From: Dave Young <dyoung@redhat.com>
To: ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kexec: do not call kmsg_dump in crashdump
Message-ID: <20111125081959.GA2505@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mtd/ram oops dumper will make more functions envolved. In case crash kexec, 
we should avoid kmsg dumper to ensure crashdump success.

kill kmsg_dump callback while crash dumping 

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 kernel/kexec.c |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.orig/kernel/kexec.c	2011-11-18 16:34:18.000000000 +0800
+++ linux-2.6/kernel/kexec.c	2011-11-24 16:05:08.138660500 +0800
@@ -1094,8 +1094,6 @@ void crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
-			kmsg_dump(KMSG_DUMP_KEXEC);
-
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
