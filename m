Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab1FLShp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 14:37:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60350 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1FLSho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 14:37:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to;
        b=If9mMnlsrLEoXR8S2nq1ny4jfitxDs7OizogEaq+ht18tAcc+yD6vg+YSs2IvFYfxM
         dkl/Ouz0bg+K/bJNXhwd1p+sXEME2M+FF+7Nbr95vvpZdZ/+kSHctm7BOkrl9GgmWjQv
         EPKsxVYg5F+libsto0TCq8Ce0yAk4LnmiWTN4=
Date: Sun, 12 Jun 2011 12:36:28 -0600
From: Jean Sacren <sakiwit@gmail.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] boot: Enhance performance by eliminating
 unnecessary calls to printf()
Message-ID: <20110612183627.GA12311@mail.gmail.com>
References: <20110606004038.GA28970@mail.gmail.com>
 <4DED0990.8090309@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DED0990.8090309@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Mon, 06 Jun 2011 10:08:32 -0700
>
> On 06/05/2011 05:40 PM, Jean Sacren wrote:
> > Hi,
> > 
> > Repeated calling to printf() for 13 times is a dire waste of CPU cycles.
> > For performance, combine all those calls into one while source code
> > formatting is preserved for readability.
> > 
> > Compile tested only.
> > 
> > Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> 
> You're got to be bloody kidding.

You're quite strong in opinion, but rather weak in code. Sadly you even
didn't get the contraction right...
> 
> First of all, this is a build time tool which is executed exactly once
> during the entire kernel build.
> 
> Second, printf execution time is largely dependent on the size
> formatting string; since the I/O is buffered it is only issued once
> anyway... which basically means that there is no time saved at all.

The above two arguments have nothing to do with the fact you printed out
13 lines individually, where they should have been printed out
collectively. To make my point here, why you didn't print out each
character individually?

I looked at the history of the file and the way you did it is a birth
shortcoming. For the past two years, no code has ever been necessarily
inserted between these 13 printf() calls. Looking into the future, that
block of code shall be facilitated by the updated patch.
> 
> Third, the resulting code is substantially harder to read.

With the updated patch, this argument doesn't stand at all.
> 
> Fourth, carrying this as a patch will cost kernel developers more time
> in additional git execution time than it ever will save them in build time.

With the updated patch, this argument doesn't make any sense at all.
> 
> Nacked-by: H. Peter Anvin <hpa@zytor.com>
> 
> 	-hpa

From: Jean Sacren <sakiwit@gmail.com>
Date: Sun, 12 Jun 2011 04:15:30 -0600
Subject: [PATCH 1/1] boot: Enhance performance by eliminating unnecessary calls to printf()

Repeated calling to printf() for 13 times is a dire waste of CPU cycles.
For performance, combine all those calls into one while source code
formatting is preserved for readability.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 arch/x86/boot/compressed/mkpiggy.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index 46a8238..1e21fca 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -82,21 +82,21 @@ int main(int argc, char *argv[])
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
+	printf(".section \".rodata..compressed\",\"a\",@progbits\n"
+	       ".globl z_input_len\n"
+	       "z_input_len = %lu\n"
+	       ".globl z_output_len\n"
+	       "z_output_len = %lu\n"
+	       ".globl z_extract_offset\n"
+	       "z_extract_offset = 0x%lx\n"
+	       ".globl z_extract_offset_negative\n"
+	       "z_extract_offset_negative = -0x%lx\n"
+	       ".globl input_data, input_data_end\n"
+	       "input_data:\n"
+	       ".incbin \"%s\"\n"
+	       "input_data_end:\n",
+	       ilen, (unsigned long)olen, offs, offs, argv[1]);
 
 	return 0;
 }
-- 
1.7.2.2

-- 
Jean Sacren
