Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab2JFUUo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:20:44 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59199 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab2JFUUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:20:38 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 36/49] tools/power/acpi/acpidump: create acpidump(8), local make install targets
Date: Sat,  6 Oct 2012 16:09:57 -0400
Message-Id: <0e7cc27935cda92c7a39a00791d0d4bbffeab117.1349554106.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349554210-29978-1-git-send-email-lenb@kernel.org>
References: <1349554210-29978-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/acpi/Makefile   |  4 +++
 tools/power/acpi/acpidump.8 | 59 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)
 create mode 100644 tools/power/acpi/acpidump.8

diff --git a/tools/power/acpi/Makefile b/tools/power/acpi/Makefile
index dad79a6..6b9cf7a 100644
--- a/tools/power/acpi/Makefile
+++ b/tools/power/acpi/Makefile
@@ -12,3 +12,7 @@ CLEANFILES= $(PROG)
 clean : 
 	rm -f $(CLEANFILES) $(patsubst %.c,%.o, $(SRCS)) *~
 
+install :
+	install acpidump /usr/bin/acpidump
+	install acpidump.8 /usr/share/man/man8
+
diff --git a/tools/power/acpi/acpidump.8 b/tools/power/acpi/acpidump.8
new file mode 100644
index 0000000..adfa991
--- /dev/null
+++ b/tools/power/acpi/acpidump.8
@@ -0,0 +1,59 @@
+.TH ACPIDUMP 8
+.SH NAME
+acpidump \- Dump system's ACPI tables to an ASCII file.
+.SH SYNOPSIS
+.ft B
+.B acpidump > acpidump.out
+.SH DESCRIPTION
+\fBacpidump \fP dumps the systems ACPI tables to an ASCII file
+appropriate for attaching to a bug report.
+
+Subsequently, they can be processed by utilities in the ACPICA package.
+.SS Options
+no options worth worrying about.
+.PP
+.SH EXAMPLE
+
+.nf
+# acpidump > acpidump.out
+
+$ acpixtract -a acpidump.out
+        Acpi table [DSDT] -  15974 bytes written to DSDT.dat
+        Acpi table [FACS] -     64 bytes written to FACS.dat
+        Acpi table [FACP] -    116 bytes written to FACP.dat
+        Acpi table [APIC] -    120 bytes written to APIC.dat
+        Acpi table [MCFG] -     60 bytes written to MCFG.dat
+        Acpi table [SSDT] -    444 bytes written to SSDT1.dat
+        Acpi table [SSDT] -    439 bytes written to SSDT2.dat
+        Acpi table [SSDT] -    439 bytes written to SSDT3.dat
+        Acpi table [SSDT] -    439 bytes written to SSDT4.dat
+        Acpi table [SSDT] -    439 bytes written to SSDT5.dat
+        Acpi table [RSDT] -     76 bytes written to RSDT.dat
+        Acpi table [RSDP] -     20 bytes written to RSDP.dat
+
+$ iasl -d *.dat
+...
+.fi
+creates *.dsl, a human readable form which can be edited
+and compiled using iasl.
+
+
+.SH NOTES
+
+.B "acpidump "
+must be run as root.
+
+.SH REFERENCES
+ACPICA: https://acpica.org/
+
+.SH FILES
+.ta
+.nf
+/dev/mem
+/sys/firmware/acpi/tables/dynamic/*
+.fi
+
+.PP
+.SH AUTHOR
+.nf
+Written by Len Brown <len.brown@intel.com>
-- 
1.8.0.rc0.18.gf84667d

