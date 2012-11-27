Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab2K0ORy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:17:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348Ab2K0ORx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:17:53 -0500
From: Petr Tesarik <ptesarik@suse.cz>
To: Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: Save PG_compound or PG_head value in VMCOREINFO
Date: Tue, 27 Nov 2012 15:13:32 +0100
Message-ID: <3774326.lMtTTFYZT3@azariah.suse.cz>
Organization: SUSE LINUX, s.r.o.
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; i686; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allow filtering of huge pages, makedumpfile must be able to identify
them in the dump. This can be done by checking for the appropriate
page flag, so communicate its value to makedumpfile through the VMCOREINFO 
interface.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>

---
 kernel/kexec.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1511,6 +1511,11 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
 	VMCOREINFO_NUMBER(PG_lru);
 	VMCOREINFO_NUMBER(PG_private);
+#ifdef CONFIG_PAGEFLAGS_EXTENDED
+	VMCOREINFO_NUMBER(PG_head);
+#else
+	VMCOREINFO_NUMBER(PG_compound);
+#endif
 	VMCOREINFO_NUMBER(PG_swapcache);
 
 	arch_crash_save_vmcoreinfo();

