Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab1DZTdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:33:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52854 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab1DZTdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:33:31 -0400
Date: Tue, 26 Apr 2011 12:33:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>,
        Peter Foley <pefoley2@verizon.net>,
        torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v2] init/Kconfig: fix EXPERT menu list
Message-Id: <20110426123321.b17de254.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DB71E05.0075:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The EXPERT menu list was recently broken by the insertion of a
kconfig symbol (EMBEDDED) at the beginning of the EXPERT list of
kconfig items.  Broken by:

  commit 6a108a14fa356ef607be308b68337939e56ea94e
  Author: David Rientjes <rientjes@google.com>
  Date:   Thu Jan 20 14:44:16 2011 -0800
    kconfig: rename CONFIG_EMBEDDED to CONFIG_EXPERT

Restore the EXPERT menu list -- don't inject a symbol (EMBEDDED)
that does not depend on EXPERT into the list.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Peter Foley <pefoley2@verizon.net>
---
 init/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- lnx-2639-rc4.orig/init/Kconfig
+++ lnx-2639-rc4/init/Kconfig
@@ -924,14 +924,6 @@ menuconfig EXPERT
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
-config EMBEDDED
-	bool "Embedded system"
-	select EXPERT
-	help
-	  This option should be enabled if compiling the kernel for
-	  an embedded system so certain expert options are available
-	  for configuration.
-
 config UID16
 	bool "Enable 16-bit UID system calls" if EXPERT
 	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
@@ -1104,6 +1096,14 @@ config AIO
           by some high performance threaded applications. Disabling
           this option saves about 7k.
 
+config EMBEDDED
+	bool "Embedded system"
+	select EXPERT
+	help
+	  This option should be enabled if compiling the kernel for
+	  an embedded system so certain expert options are available
+	  for configuration.
+
 config HAVE_PERF_EVENTS
 	bool
 	help
