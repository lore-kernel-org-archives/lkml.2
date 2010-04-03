Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab0DCSg6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 14:36:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32855 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603Ab0DCSgw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 14:36:52 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-pci <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <1270319696.12516.321.camel@localhost>
References: <1270319696.12516.321.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 03 Apr 2010 19:36:42 +0100
Message-ID: <1270319802.12516.323.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 2/4] panic: Add taint flag TAINT_FIRMWARE_WORKAROUND ('I')
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This taint flag will initially be used when warning about invalid ACPI
DMAR tables.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
Changes since the previous version:
- Added note to Documentation/oops-tracing.txt

Ben.

 Documentation/oops-tracing.txt |    3 +++
 include/linux/kernel.h         |    1 +
 kernel/panic.c                 |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
index 069fab3..6fe9001 100644
--- a/Documentation/oops-tracing.txt
+++ b/Documentation/oops-tracing.txt
@@ -260,6 +260,9 @@ characters, each representing a particular tainted value.
 
  11: 'C' if a staging driver has been loaded.
 
+ 12: 'I' if the kernel is working around a severe bug in the platform
+     firmware (BIOS or similar).
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 7f07074..7f2f7b3 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -344,6 +344,7 @@ extern enum system_states {
 #define TAINT_OVERRIDDEN_ACPI_TABLE	8
 #define TAINT_WARN			9
 #define TAINT_CRAP			10
+#define TAINT_FIRMWARE_WORKAROUND	11
 
 extern void dump_stack(void) __cold;
 
diff --git a/kernel/panic.c b/kernel/panic.c
index 8b821bc..dbe13db 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -178,6 +178,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_OVERRIDDEN_ACPI_TABLE,	'A', ' ' },
 	{ TAINT_WARN,			'W', ' ' },
 	{ TAINT_CRAP,			'C', ' ' },
+	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
 };
 
 /**
@@ -194,6 +195,7 @@ static const struct tnt tnts[] = {
  *  'A' - ACPI table overridden.
  *  'W' - Taint on warning.
  *  'C' - modules from drivers/staging are loaded.
+ *  'I' - Working around severe firmware bug.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
-- 
1.7.0.3



