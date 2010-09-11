Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab0IKFNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 01:13:35 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:38593 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab0IKFNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 01:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to;
        b=JOgCxHwZDdIQTKwtlkR6MKNlzyEf0E8+10ocDaqZ8HwoRKSWda9Zfi38++WXrBmaxa
         +AUmjDGC77wPguv7LH2aBSIPoZbpDe6P/0BaikOz+URQHZ6Hf4QDzLWBIpYqE4q7KzOq
         6w0d6N3Fp/IekoEuVfFyAO2iABN2hxXgX1wng=
Date: Fri, 10 Sep 2010 23:13:33 -0600
From: Jean Sacren <sakiwit@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] scripts: Enable error messages while hush up
 unnecessary warnings
Message-ID: <20100911051333.GA18189@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100911051053.GA18094@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As no error was handled, we wouldn't be able to know when an error does
occur. The fix preserves error messages while it doesn't let unnecessary
compiling warnings show up.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 scripts/kallsyms.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index e3902fb..60dd3eb 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -107,12 +107,8 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 
 	rc = fscanf(in, "%llx %c %499s\n", &s->addr, &stype, str);
 	if (rc != 3) {
-		if (rc != EOF) {
-			/* skip line. sym is used as dummy to
-			 * shut of "warn_unused_result" warning.
-			 */
-			sym = fgets(str, 500, in);
-		}
+		if (rc != EOF && fgets(str, 500, in) == NULL)
+			fprintf(stderr, "Read error or end of file.\n");
 		return -1;
 	}
 
-- 
1.7.1
