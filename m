Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1FFAkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 20:40:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35632 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab1FFAkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 20:40:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition;
        b=BmBQyiuRPcys1uhvJ+CkB9XgAuKkJDWO+nJ1lnmMs1KxRIbXW8oChGPf2dtJbLVt/v
         CIcjUUewac/iwmBSr8V5u0/6VI7/vPtCR3HQnipn1iROdN9kYNcqM/2sSJ06yUfL24Fp
         67pmgNw6EvqRppj5e8cTspzcXcM/dpUgREnEk=
Date: Sun, 5 Jun 2011 18:40:38 -0600
From: Jean Sacren <sakiwit@gmail.com>
To: hpa@linux.intel.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] boot: Enhance performance by eliminating unnecessary
 calls to printf()
Message-ID: <20110606004038.GA28970@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Repeated calling to printf() for 13 times is a dire waste of CPU cycles.
For performance, combine all those calls into one while source code
formatting is preserved for readability.

Compile tested only.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 arch/x86/boot/compressed/mkpiggy.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index 46a8238..0b6d82c 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -44,6 +44,7 @@ int main(int argc, char *argv[])
 	long ilen;
 	unsigned long offs;
 	FILE *f;
+	char *msg;
 
 	if (argc < 2) {
 		fprintf(stderr, "Usage: %s compressed_file\n", argv[0]);
@@ -82,21 +83,22 @@ int main(int argc, char *argv[])
 	offs += 64*1024 + 128;	/* Add 64K + 128 bytes slack */
 	offs = (offs+4095) & ~4095; /* Round to a 4K boundary */
 
-	printf(".section \".rodata..compressed\",\"a\",@progbits\n");
-	printf(".globl z_input_len\n");
-	printf("z_input_len = %lu\n", ilen);
-	printf(".globl z_output_len\n");
-	printf("z_output_len = %lu\n", (unsigned long)olen);
-	printf(".globl z_extract_offset\n");
-	printf("z_extract_offset = 0x%lx\n", offs);
 	/* z_extract_offset_negative allows simplification of head_32.S */
-	printf(".globl z_extract_offset_negative\n");
-	printf("z_extract_offset_negative = -0x%lx\n", offs);
-
-	printf(".globl input_data, input_data_end\n");
-	printf("input_data:\n");
-	printf(".incbin \"%s\"\n", argv[1]);
-	printf("input_data_end:\n");
+	msg = ".section \".rodata..compressed\",\"a\",@progbits\n"
+		".globl z_input_len\n"
+		"z_input_len = %lu\n"
+		".globl z_output_len\n"
+		"z_output_len = %lu\n"
+		".globl z_extract_offset\n"
+		"z_extract_offset = 0x%lx\n"
+		".globl z_extract_offset_negative\n"
+		"z_extract_offset_negative = -0x%lx\n"
+		".globl input_data, input_data_end\n"
+		"input_data:\n"
+		".incbin \"%s\"\n"
+		"input_data_end:\n";
+
+	printf(msg, ilen, (unsigned long)olen, offs, offs, argv[1]);
 
 	return 0;
 }
-- 
1.7.2.2


-- 
Jean Sacren
