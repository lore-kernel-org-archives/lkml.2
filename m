Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756Ab1CXSvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:51:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39592 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933529Ab1CXSvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:51:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IXjuar0brJZ5Q8e3yfZSN5Oje9IC2LcyUlIMp8AO+WzMOxDwA6n5aqcTmKNkge7Fp1
         xVoYs1cQkqBZiAz/z0/u317U4nGGHM20HM0G8G8S6gJisuSPpu8CIJ5jtkzGs1/YsTZD
         uDinspV3wwESJ9I+EwZf8e4uqHF04OiIcN3Do=
Date: Thu, 24 Mar 2011 20:51:16 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, geert@linux-m68k.org
Subject: [PATCH] kstrtox: fix compile warnings in test
Message-ID: <20110324185115.GA12383@p183.telecom.by>
References: <201103230200.p2N20nBv011302@hera.kernel.org>
 <AANLkTi=JuHke7CMURU6fuBSVenD1prHfKRTqJucr0g9o@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=JuHke7CMURU6fuBSVenD1prHfKRTqJucr0g9o@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warnings:

  CC [M]  lib/test-kstrtox.o
lib/test-kstrtox.c: In function 'test_kstrtou64_ok':
lib/test-kstrtox.c:318: warning: this decimal constant is unsigned only in ISO C90
	...

Noticed by Geert Uytterhoeven <geert@linux-m68k.org>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 lib/test-kstrtox.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/lib/test-kstrtox.c
+++ b/lib/test-kstrtox.c
@@ -315,12 +315,12 @@ static void __init test_kstrtou64_ok(void)
 		{"65537",	10,	65537},
 		{"2147483646",	10,	2147483646},
 		{"2147483647",	10,	2147483647},
-		{"2147483648",	10,	2147483648},
-		{"2147483649",	10,	2147483649},
-		{"4294967294",	10,	4294967294},
-		{"4294967295",	10,	4294967295},
-		{"4294967296",	10,	4294967296},
-		{"4294967297",	10,	4294967297},
+		{"2147483648",	10,	2147483648ULL},
+		{"2147483649",	10,	2147483649ULL},
+		{"4294967294",	10,	4294967294ULL},
+		{"4294967295",	10,	4294967295ULL},
+		{"4294967296",	10,	4294967296ULL},
+		{"4294967297",	10,	4294967297ULL},
 		{"9223372036854775806",	10,	9223372036854775806ULL},
 		{"9223372036854775807",	10,	9223372036854775807ULL},
 		{"9223372036854775808",	10,	9223372036854775808ULL},
@@ -369,12 +369,12 @@ static void __init test_kstrtos64_ok(void)
 		{"65537",	10,	65537},
 		{"2147483646",	10,	2147483646},
 		{"2147483647",	10,	2147483647},
-		{"2147483648",	10,	2147483648},
-		{"2147483649",	10,	2147483649},
-		{"4294967294",	10,	4294967294},
-		{"4294967295",	10,	4294967295},
-		{"4294967296",	10,	4294967296},
-		{"4294967297",	10,	4294967297},
+		{"2147483648",	10,	2147483648LL},
+		{"2147483649",	10,	2147483649LL},
+		{"4294967294",	10,	4294967294LL},
+		{"4294967295",	10,	4294967295LL},
+		{"4294967296",	10,	4294967296LL},
+		{"4294967297",	10,	4294967297LL},
 		{"9223372036854775806",	10,	9223372036854775806LL},
 		{"9223372036854775807",	10,	9223372036854775807LL},
 	};
@@ -418,10 +418,10 @@ static void __init test_kstrtou32_ok(void)
 		{"65537",	10,	65537},
 		{"2147483646",	10,	2147483646},
 		{"2147483647",	10,	2147483647},
-		{"2147483648",	10,	2147483648},
-		{"2147483649",	10,	2147483649},
-		{"4294967294",	10,	4294967294},
-		{"4294967295",	10,	4294967295},
+		{"2147483648",	10,	2147483648U},
+		{"2147483649",	10,	2147483649U},
+		{"4294967294",	10,	4294967294U},
+		{"4294967295",	10,	4294967295U},
 	};
 	TEST_OK(kstrtou32, u32, "%u", test_u32_ok);
 }
