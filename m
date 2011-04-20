Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1DTQZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:25:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:55498 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab1DTQYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:24:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Michael Witten <mfwitten@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/6] perf tools: git mv tools/perf/{features-tests.mak,config/}
Date: Wed, 20 Apr 2011 13:23:55 -0300
Message-Id: <1303316636-11923-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1303316636-11923-1-git-send-email-acme@infradead.org>
References: <1303316636-11923-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Witten <mfwitten@gmail.com>

Signed-off-by: Michael Witten <mfwitten@gmail.com>
Link: http://lkml.kernel.org/n/tip-a6zhefjayuounko1tk5sjji2@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                 |    2 +-
 tools/perf/config/feature-tests.mak |  128 +++++++++++++++++++++++++++++++++++
 tools/perf/feature-tests.mak        |  128 -----------------------------------
 3 files changed, 129 insertions(+), 129 deletions(-)
 create mode 100644 tools/perf/config/feature-tests.mak
 delete mode 100644 tools/perf/feature-tests.mak

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b5276c7..91ad5cc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -138,7 +138,7 @@ INSTALL = install
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
--include feature-tests.mak
+-include config/feature-tests.mak
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all),y)
 	CFLAGS := $(CFLAGS) -fstack-protector-all
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
new file mode 100644
index 0000000..6170fd2
--- /dev/null
+++ b/tools/perf/config/feature-tests.mak
@@ -0,0 +1,128 @@
+define SOURCE_HELLO
+#include <stdio.h>
+int main(void)
+{
+	return puts(\"hi\");
+}
+endef
+
+ifndef NO_DWARF
+define SOURCE_DWARF
+#include <dwarf.h>
+#include <elfutils/libdw.h>
+#include <elfutils/version.h>
+#ifndef _ELFUTILS_PREREQ
+#error
+#endif
+
+int main(void)
+{
+	Dwarf *dbg = dwarf_begin(0, DWARF_C_READ);
+	return (long)dbg;
+}
+endef
+endif
+
+define SOURCE_LIBELF
+#include <libelf.h>
+
+int main(void)
+{
+	Elf *elf = elf_begin(0, ELF_C_READ, 0);
+	return (long)elf;
+}
+endef
+
+define SOURCE_GLIBC
+#include <gnu/libc-version.h>
+
+int main(void)
+{
+	const char *version = gnu_get_libc_version();
+	return (long)version;
+}
+endef
+
+define SOURCE_ELF_MMAP
+#include <libelf.h>
+int main(void)
+{
+	Elf *elf = elf_begin(0, ELF_C_READ_MMAP, 0);
+	return (long)elf;
+}
+endef
+
+ifndef NO_NEWT
+define SOURCE_NEWT
+#include <newt.h>
+
+int main(void)
+{
+	newtInit();
+	newtCls();
+	return newtFinished();
+}
+endef
+endif
+
+ifndef NO_LIBPERL
+define SOURCE_PERL_EMBED
+#include <EXTERN.h>
+#include <perl.h>
+
+int main(void)
+{
+perl_alloc();
+return 0;
+}
+endef
+endif
+
+ifndef NO_LIBPYTHON
+define SOURCE_PYTHON_VERSION
+#include <Python.h>
+#if PY_VERSION_HEX >= 0x03000000
+	#error
+#endif
+int main(void){}
+endef
+define SOURCE_PYTHON_EMBED
+#include <Python.h>
+int main(void)
+{
+	Py_Initialize();
+	return 0;
+}
+endef
+endif
+
+define SOURCE_BFD
+#include <bfd.h>
+
+int main(void)
+{
+	bfd_demangle(0, 0, 0);
+	return 0;
+}
+endef
+
+define SOURCE_CPLUS_DEMANGLE
+extern char *cplus_demangle(const char *, int);
+
+int main(void)
+{
+	cplus_demangle(0, 0);
+	return 0;
+}
+endef
+
+define SOURCE_STRLCPY
+#include <stdlib.h>
+extern size_t strlcpy(char *dest, const char *src, size_t size);
+
+int main(void)
+{
+	strlcpy(NULL, NULL, 0);
+	return 0;
+}
+endef
diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
deleted file mode 100644
index 6170fd2..0000000
--- a/tools/perf/feature-tests.mak
+++ /dev/null
@@ -1,128 +0,0 @@
-define SOURCE_HELLO
-#include <stdio.h>
-int main(void)
-{
-	return puts(\"hi\");
-}
-endef
-
-ifndef NO_DWARF
-define SOURCE_DWARF
-#include <dwarf.h>
-#include <elfutils/libdw.h>
-#include <elfutils/version.h>
-#ifndef _ELFUTILS_PREREQ
-#error
-#endif
-
-int main(void)
-{
-	Dwarf *dbg = dwarf_begin(0, DWARF_C_READ);
-	return (long)dbg;
-}
-endef
-endif
-
-define SOURCE_LIBELF
-#include <libelf.h>
-
-int main(void)
-{
-	Elf *elf = elf_begin(0, ELF_C_READ, 0);
-	return (long)elf;
-}
-endef
-
-define SOURCE_GLIBC
-#include <gnu/libc-version.h>
-
-int main(void)
-{
-	const char *version = gnu_get_libc_version();
-	return (long)version;
-}
-endef
-
-define SOURCE_ELF_MMAP
-#include <libelf.h>
-int main(void)
-{
-	Elf *elf = elf_begin(0, ELF_C_READ_MMAP, 0);
-	return (long)elf;
-}
-endef
-
-ifndef NO_NEWT
-define SOURCE_NEWT
-#include <newt.h>
-
-int main(void)
-{
-	newtInit();
-	newtCls();
-	return newtFinished();
-}
-endef
-endif
-
-ifndef NO_LIBPERL
-define SOURCE_PERL_EMBED
-#include <EXTERN.h>
-#include <perl.h>
-
-int main(void)
-{
-perl_alloc();
-return 0;
-}
-endef
-endif
-
-ifndef NO_LIBPYTHON
-define SOURCE_PYTHON_VERSION
-#include <Python.h>
-#if PY_VERSION_HEX >= 0x03000000
-	#error
-#endif
-int main(void){}
-endef
-define SOURCE_PYTHON_EMBED
-#include <Python.h>
-int main(void)
-{
-	Py_Initialize();
-	return 0;
-}
-endef
-endif
-
-define SOURCE_BFD
-#include <bfd.h>
-
-int main(void)
-{
-	bfd_demangle(0, 0, 0);
-	return 0;
-}
-endef
-
-define SOURCE_CPLUS_DEMANGLE
-extern char *cplus_demangle(const char *, int);
-
-int main(void)
-{
-	cplus_demangle(0, 0);
-	return 0;
-}
-endef
-
-define SOURCE_STRLCPY
-#include <stdlib.h>
-extern size_t strlcpy(char *dest, const char *src, size_t size);
-
-int main(void)
-{
-	strlcpy(NULL, NULL, 0);
-	return 0;
-}
-endef
-- 
1.6.2.5

