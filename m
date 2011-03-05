Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1CETlr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 14:41:47 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33550 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1CETlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 14:41:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:x-face:face:x-url:x-pgp-fp
         :x-pgp:date:in-reply-to:message-id:user-agent:mime-version
         :content-type;
        b=i0ZeG6bbhUgqqg406ptuXD7WCB/rOaSBxITJh21wMpe7VXo6JfMCPcRTu7eH+Ji1if
         ikboEg24zKHc3sJDTaUAAT+63Z7eRtxmUV8pWw/AhxKzTUVLyoKIr/D+ilzjnA5BA+PQ
         Twl4Mwdpzm2GR6l++c6JZIYdBz5c6w+1bx68A=
From: Michal Nazarewicz <mina86@mina86.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Denis Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] lib: vsprintf: 32-bit put_dec() fixes
References: <alpine.LSU.2.00.1103050436010.4098@sister.anvils>
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Sat, 05 Mar 2011 20:41:40 +0100
In-Reply-To: <alpine.LSU.2.00.1103050436010.4098@sister.anvils> (Hugh
	Dickins's message of "Sat, 5 Mar 2011 04:42:30 -0800 (PST)")
Message-ID: <87k4gd73t7.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes the 32-bit put_dec() function.

I have submitted by mistake an older version of the put_dec()
patch with a bug in it (which had been spotted by Denys and
fixed in subsequent version), which resulted in Hugh having to
find the bug once again (after experiencing boot failure).

This commit fixes the bug once and for all and introduces some
additional optimisations and comments (which were present in
the fixed version of put_dec() patch).

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Hugh Dickins <hughd@google.com>
---
 lib/vsprintf.c |   49 ++++++++++++++++++++++++-------------------------
 1 files changed, 24 insertions(+), 25 deletions(-)

Hugh Dickins <hughd@google.com> writes:
> mmotm 2011-03-02-16-52 is utterly broken on 32-bit: panics
> at boot with "Couldn't register console driver", and
> preceding warnings don't even print their line
> numbers... which leads to the vsprintf changes.

As I suspected, I sent by mistake the v3 instead of v4 of the
patch.  I haven't spotted any problems because I was building
kernel for my 32-bit machine from a branch with a fix but than
sent patch from a branch for 64-bit machine (which was not
affected by the bug).

Hugh proposed version with cascades of ifs.  I think this is
better version because it's smaller and benchmark are not
clear which version is faster (on Intel version with ifs was
faster but on ARM version without ifs was).

I pushed an unified version of the whole put_dec patch,
rebased on v2.6.38-rc7, to github:

        git://github.com/mina86/linux-2.6.git v2.6.38-rc7+put-dec

The attached patch is rebased on top of -mm (ie. just a delta).

For the sake of elegance, I would probably recommend taking
the unified patch instead of what's already in -mm plus this
or Hugh's fix.

Again, sorry about all the problems.

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 344c03f..daa9209 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -157,7 +157,7 @@ static noinline_for_stack char *put_dec_full5(char *buf, unsigned q)
 	 * without any branches.
 	 */
 
-	r      = (q * (uint64_t)0xcccd) >> 19;
+	r = (q * (uint64_t)0xcccd) >> 19;
 	*buf++ = (q - 10 * r) + '0';
 
 	/*
@@ -226,7 +226,14 @@ static noinline_for_stack char *put_dec_trunc5(char *buf, unsigned q)
 	return buf;
 }
 
-/* No inlining helps gcc to use registers better */
+/*
+ * This function formats all integers correctly, however on 32-bit
+ * processors function below is used (not this one) which handles only
+ * non-zero integers.  So be advised never to call this function with
+ * num == 0.
+ *
+ * No inlining helps gcc to use registers better
+ */
 static noinline_for_stack
 char *put_dec(char *buf, unsigned long long num)
 {
@@ -293,36 +300,36 @@ char *put_dec_8bit(char *buf, unsigned q)
  * permission from the author).  This performs no 64-bit division and
  * hence should be faster on 32-bit machines then the version of the
  * function above.
+ *
+ * This function formats correctly all NON-ZERO integers.  Passing
+ * zero makes daemons come out of your closet.  This is OK, since
+ * number(), which calls this function, has a special case for zero
+ * anyways.
  */
 static noinline_for_stack
 char *put_dec(char *buf, unsigned long long n)
 {
 	uint32_t d3, d2, d1, q;
 
-	if (n < 10) {
-		*buf++ = '0' + (unsigned)n;
-		return buf;
-	}
-
 	d1 = (n >> 16) & 0xFFFF;
 	d2 = (n >> 32) & 0xFFFF;
 	d3 = (n >> 48) & 0xFFFF;
 
-	q  = 656 * d3 + 7296 * d2 + 5536 * d1 + (n & 0xFFFF);
+	q = 656 * d3 + 7296 * d2 + 5536 * d1 + (n & 0xFFFF);
 
-	q  = q / 10000;
 	buf = put_dec_full4(buf, q % 10000);
+	q = q / 10000;
 
 	d1 = q + 7671 * d3 + 9496 * d2 + 6 * d1;
-	q  = d1 / 10000;
+	q = d1 / 10000;
 	buf = put_dec_full4(buf, d1 % 10000);
 
 	d2 = q + 4749 * d3 + 42 * d2;
-	q  = d2 / 10000;
+	q = d2 / 10000;
 	buf = put_dec_full4(buf, d2 % 10000);
 
 	d3 = q + 281 * d3;
-	q  = d3 / 10000;
+	q = d3 / 10000;
 	buf = put_dec_full4(buf, d3 % 10000);
 
 	buf = put_dec_full4(buf, q);
@@ -407,22 +414,14 @@ char *number(char *buf, char *end, unsigned long long num,
 			spec.field_width--;
 		}
 	}
-	if (need_pfx) {
-		spec.field_width--;
-		if (spec.base == 16)
-			spec.field_width--;
-	}
+	if (need_pfx)
+		spec.field_width -= spec.base / 8;
 
 	/* generate full string in tmp[], in reverse order */
 	i = 0;
-	if (num == 0)
-		tmp[i++] = '0';
-	/* Generic code, for any base:
-	else do {
-		tmp[i++] = (digits[do_div(num,base)] | locase);
-	} while (num != 0);
-	*/
-	else if (spec.base != 10) { /* 8 or 16 */
+	if (num < 8) {
+		tmp[i++] = '0' + (char)num;
+	} else if (spec.base != 10) { /* 8 or 16 */
 		int mask = spec.base - 1;
 		int shift = 3;
 
-- 
1.7.1
