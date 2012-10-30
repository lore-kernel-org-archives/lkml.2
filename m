Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965176Ab2J3RiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:38:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965014Ab2J3RiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:38:10 -0400
Date: Tue, 30 Oct 2012 13:38:05 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
Subject: [PATCH] tools: Allow tools to be installed in a user specified
 location
Message-ID: <20121030173805.GC6627@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building x86_energy_perf_policy or turbostat within the confines of
a packaging system such as RPM, we need to be able to have it install to
the buildroot and not the root filesystem of the build machine.  This
adds a DESTDIR variable that when set will act as a prefix for the
install location of these tools.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>

---

diff --git a/tools/power/x86/turbostat/Makefile b/tools/power/x86/turbostat/Makefile
index f856495..984cc00 100644
--- a/tools/power/x86/turbostat/Makefile
+++ b/tools/power/x86/turbostat/Makefile
@@ -1,3 +1,5 @@
+DESTDIR ?=
+
 turbostat : turbostat.c
 CFLAGS +=	-Wall
 
@@ -5,5 +7,5 @@ clean :
 	rm -f turbostat
 
 install :
-	install turbostat /usr/bin/turbostat
-	install turbostat.8 /usr/share/man/man8
+	install turbostat ${DESTDIR}/usr/bin/turbostat
+	install turbostat.8 ${DESTDIR}/usr/share/man/man8
diff --git a/tools/power/x86/x86_energy_perf_policy/Makefile b/tools/power/x86/x86_energy_perf_policy/Makefile
index f458237..f9824f0 100644
--- a/tools/power/x86/x86_energy_perf_policy/Makefile
+++ b/tools/power/x86/x86_energy_perf_policy/Makefile
@@ -1,8 +1,10 @@
+DESTDIR ?= 
+
 x86_energy_perf_policy : x86_energy_perf_policy.c
 
 clean :
 	rm -f x86_energy_perf_policy
 
 install :
-	install x86_energy_perf_policy /usr/bin/
-	install x86_energy_perf_policy.8 /usr/share/man/man8/
+	install x86_energy_perf_policy ${DESTDIR}/usr/bin/
+	install x86_energy_perf_policy.8 ${DESTDIR}/usr/share/man/man8/
