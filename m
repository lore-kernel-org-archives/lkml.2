Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3AAVRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 16:17:07 -0500
Received: from nm19-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.25]:25301
	"EHLO nm19-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480Ab3AAVRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 16:17:03 -0500
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jan 2013 16:17:03 EST
X-Yahoo-Newman-Id: 532015.17119.bm@smtp109.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: OVCBEl4VM1n1IrDrQ_tcxOGDgds.RMeDKaSvO..qk5vXpwT
 8.l12SInfNILQ9JiyZc4ff9jZ66CKmawee5t8Ss2PLZ_6Pg.8mJWiW4iyLWj
 SR_2.JoZs.11q1_ixn238HLBINyqMErcJjJzoUJojhMAdLvpnKiRFjKGBhSe
 Qgb8P6MqsVe63sewBAVNpalX4jlGk6RoTVGNve_0N45RJokhCwMXbOyumSc0
 7fG2Hj1dFNPjO7Kninj33LMIpMVrueAT3VM9lc7OEEerMckPWbd6CkRH.YQ8
 jKGebCROs32p2QFuxW9h5rueXCFGgWMCBHfY7Gwy64AS40lMBKP4hdKUccrE
 Uu5ObZX5MJrGXof1QRAHHtq7vl3xarguf81BvIIcmOEE064ZBJaiQxvtiJcG
 UcqIWwophqvcTtbHDNW_yzfBitA.Tm3nzd.TO_6yBlUTIZ00lfVHfRTQo2fA
 IrCYCGRMST1BsnuuG_VThbeLqt65b_rUsABeisvLt.GoTkLUB1.EC.vcOJef
 gYWi55ZWB0VWblLjVZaNbtki.Zzll4QPjVtUZ5eBDOAsrBrX_mHNcoLeOGOn
 wKA.wrSaOOkkIKK4mUQE-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v7 2/9] compiler-gcc.h: Add gcc-recommended GCC_VERSION macro
Date: Tue,  1 Jan 2013 15:09:50 -0600
Message-Id: <1357074597-21722-2-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1357074597-21722-1-git-send-email-daniel.santos@pobox.com>
References: <1357074491-21669-1-git-send-email-daniel.santos@pobox.com>
 <1357074597-21722-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Throughout compiler*.h, many version checks are made.  These can be
simplified by using the macro that gcc's documentation recommends.
However, my primary reason for adding this is that I need bug-check
macros that are enabled at certain gcc versions and it's cleaner to use
this macro than the tradition method:

if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ => 2)

If you add patch level, it gets this ugly:

if __GNUC__ > 4 || (__GNUC__ == 4 && (__GNUC_MINOR__ > 2 || \
   __GNUC_MINOR__ == 2 __GNUC_PATCHLEVEL__ >= 1))

As opposed to:

if GCC_VERSION >= 40201

While having separate headers for gcc 3 & 4 eliminates some of this
verbosity, they can still be cleaned up by this.

See also:
http://gcc.gnu.org/onlinedocs/cpp/Common-Predefined-Macros.html

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: Borislav Petkov <bp@alien8.de>
Acked-by: David Rientjes <rientjes@google.com>
---
 include/linux/compiler-gcc.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 6a6d7ae..24545cd 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -5,6 +5,9 @@
 /*
  * Common definitions for all gcc versions go here.
  */
+#define GCC_VERSION (__GNUC__ * 10000 \
+		   + __GNUC_MINOR__ * 100 \
+		   + __GNUC_PATCHLEVEL__)
 
 
 /* Optimization barrier */
-- 
1.7.8.6

