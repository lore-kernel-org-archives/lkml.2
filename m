Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab1ERSbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:31:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:44684 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933393Ab1ERSbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:31:52 -0400
Date: Wed, 18 May 2011 18:31:37 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-e90b0c8bf211958a296d60369fecd51b35864407@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, srostedt@redhat.com, jreiser@bitwagon.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, jreiser@bitwagon.com,
        tglx@linutronix.de
In-Reply-To: <20110421023737.523968644@goodmis.org>
References: <20110421023737.523968644@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace/trivial: Clean up record mcount to use Linux switch style
Git-Commit-ID: e90b0c8bf211958a296d60369fecd51b35864407
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 18:31:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e90b0c8bf211958a296d60369fecd51b35864407
Gitweb:     http://git.kernel.org/tip/e90b0c8bf211958a296d60369fecd51b35864407
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 6 Apr 2011 13:32:24 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 16 May 2011 14:41:07 -0400

ftrace/trivial: Clean up record mcount to use Linux switch style

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
Link: http://lkml.kernel.org/r/20110421023737.523968644@goodmis.org
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
