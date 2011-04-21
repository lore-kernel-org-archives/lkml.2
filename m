Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab1DUCho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:37:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33535 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1DUChj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:37:39 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=67tXhsohBooA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=SyI_GHdlAAAA:8 a=meVymXHHAAAA:8 a=newhXfnPRNPQplt3jLUA:9 a=FiZIyLWqjbEO5HJ39wwA:7 a=jEp0ucaQiEUA:10 a=UQxMgyrMzRwA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110421023737.523968644@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 22:28:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Reiser <jreiser@bitwagon.com>
Subject: [RFC][PATCH 02/11] ftrace/trivial: Clean up record mcount to use Linux switch style
References: <20110421022825.535486725@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-trivial-Clean-up-record-mcount-to-use-Linux-s.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The Linux style for switch statements is:

	switch (var) {
	case x:
		[...]
		break;
	}

Not:
	switch (var) {
	case x: {
		[...]
	} break;

Cc: John Reiser <jreiser@bitwagon.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.c |   43 ++++++++++++++++++++++---------------------
 1 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 37afe0e..4ebd839 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -264,27 +264,27 @@ do_file(char const *const fname)
 	w8 = w8nat;
 	switch (ehdr->e_ident[EI_DATA]) {
 		static unsigned int const endian = 1;
-	default: {
+	default:
 		fprintf(stderr, "unrecognized ELF data encoding %d: %s\n",
 			ehdr->e_ident[EI_DATA], fname);
 		fail_file();
-	} break;
-	case ELFDATA2LSB: {
+		break;
+	case ELFDATA2LSB:
 		if (*(unsigned char const *)&endian != 1) {
 			/* main() is big endian, file.o is little endian. */
 			w = w4rev;
 			w2 = w2rev;
 			w8 = w8rev;
 		}
-	} break;
-	case ELFDATA2MSB: {
+		break;
+	case ELFDATA2MSB:
 		if (*(unsigned char const *)&endian != 0) {
 			/* main() is little endian, file.o is big endian. */
 			w = w4rev;
 			w2 = w2rev;
 			w8 = w8rev;
 		}
-	} break;
+		break;
 	}  /* end switch */
 	if (memcmp(ELFMAG, ehdr->e_ident, SELFMAG) != 0
 	||  w2(ehdr->e_type) != ET_REL
@@ -295,11 +295,11 @@ do_file(char const *const fname)
 
 	gpfx = 0;
 	switch (w2(ehdr->e_machine)) {
-	default: {
+	default:
 		fprintf(stderr, "unrecognized e_machine %d %s\n",
 			w2(ehdr->e_machine), fname);
 		fail_file();
-	} break;
+		break;
 	case EM_386:	 reltype = R_386_32;                   break;
 	case EM_ARM:	 reltype = R_ARM_ABS32;
 			 altmcount = "__gnu_mcount_nc";
@@ -315,12 +315,12 @@ do_file(char const *const fname)
 	}  /* end switch */
 
 	switch (ehdr->e_ident[EI_CLASS]) {
-	default: {
+	default:
 		fprintf(stderr, "unrecognized ELF class %d %s\n",
 			ehdr->e_ident[EI_CLASS], fname);
 		fail_file();
-	} break;
-	case ELFCLASS32: {
+		break;
+	case ELFCLASS32:
 		if (w2(ehdr->e_ehsize) != sizeof(Elf32_Ehdr)
 		||  w2(ehdr->e_shentsize) != sizeof(Elf32_Shdr)) {
 			fprintf(stderr,
@@ -334,7 +334,7 @@ do_file(char const *const fname)
 			is_fake_mcount32 = MIPS32_is_fake_mcount;
 		}
 		do32(ehdr, fname, reltype);
-	} break;
+		break;
 	case ELFCLASS64: {
 		Elf64_Ehdr *const ghdr = (Elf64_Ehdr *)ehdr;
 		if (w2(ghdr->e_ehsize) != sizeof(Elf64_Ehdr)
@@ -352,7 +352,8 @@ do_file(char const *const fname)
 			is_fake_mcount64 = MIPS64_is_fake_mcount;
 		}
 		do64(ghdr, fname, reltype);
-	} break;
+		break;
+	}
 	}  /* end switch */
 
 	cleanup();
@@ -386,23 +387,23 @@ main(int argc, char const *argv[])
 			continue;
 
 		switch (sjval) {
-		default: {
+		default:
 			fprintf(stderr, "internal error: %s\n", argv[0]);
 			exit(1);
-		} break;
-		case SJ_SETJMP: {  /* normal sequence */
+			break;
+		case SJ_SETJMP:    /* normal sequence */
 			/* Avoid problems if early cleanup() */
 			fd_map = -1;
 			ehdr_curr = NULL;
 			mmap_failed = 1;
 			do_file(argv[0]);
-		} break;
-		case SJ_FAIL: {  /* error in do_file or below */
+			break;
+		case SJ_FAIL:    /* error in do_file or below */
 			++n_error;
-		} break;
-		case SJ_SUCCEED: {  /* premature success */
+			break;
+		case SJ_SUCCEED:    /* premature success */
 			/* do nothing */
-		} break;
+			break;
 		}  /* end switch */
 	}
 	return !!n_error;
-- 
1.7.2.3


