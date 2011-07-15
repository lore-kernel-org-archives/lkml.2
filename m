Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab1GOEXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 00:23:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:59350 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab1GOEXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 00:23:50 -0400
Date: Fri, 15 Jul 2011 04:23:42 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-7f79ad15f33cf4968cafb0e3d2beba427de01d3a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <de0b50920469ff6359c529526e7639fdd36fa83c.1310563276.git.luto@mit.edu>
References: <de0b50920469ff6359c529526e7639fdd36fa83c.1310563276.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Add --no-undefined to vDSO build
Git-Commit-ID: 7f79ad15f33cf4968cafb0e3d2beba427de01d3a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Jul 2011 04:23:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f79ad15f33cf4968cafb0e3d2beba427de01d3a
Gitweb:     http://git.kernel.org/tip/7f79ad15f33cf4968cafb0e3d2beba427de01d3a
Author:     Andy Lutomirski <luto@mit.edu>
AuthorDate: Wed, 13 Jul 2011 09:24:12 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 13 Jul 2011 11:23:09 -0700

x86-64: Add --no-undefined to vDSO build

This gives much nicer diagnostics when something goes wrong.  It's
supported at least as far back as binutils 2.15.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Link: http://lkml.kernel.org/r/de0b50920469ff6359c529526e7639fdd36fa83c.1310563276.git.luto@mit.edu
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index bef0bc9..5d17950 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -26,6 +26,7 @@ targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
 export CPPFLAGS_vdso.lds += -P -C
 
 VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
+			-Wl,--no-undefined \
 		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
 
 $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
