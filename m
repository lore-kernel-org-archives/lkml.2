Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2IYXa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:30:28 -0400
Received: from nm4.bullet.mail.sp2.yahoo.com ([98.139.91.74]:35153 "HELO
	nm4.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752459Ab2IYXaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:30:25 -0400
X-Yahoo-Newman-Id: 375504.65526.bm@omp1002.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: s9HSxVUVM1koulAX.jiZlCFSg3XrbRktV_ufEBOa6i.cv9T
 4asg9btc01AZlLdt9oy6teokorJ1fekOCJnD0azAuMZY4UOChsYuLB2bQn30
 WTIxrD9fryF8GWwGBrnNu6lsOGzmqDu_DqMUH4wK_svxBZmo5GJ8uycfTbvH
 nMjAN9GnBZjAwMWhWmmyAtwoHvTPPKsVhEZ5XLuALaHRX0zKWKYadQxgWz6D
 Vp.kZr6jMhpgLd3BMgJJB54a0EjWXKLUJNZHvQzvY0sJYsBMiSzggfLHBzCC
 .mSpTo9AuhtXwZrL7lDE5xyl2INVGVsWBne5RZbTX0.3.8mU2cNiguvqCQ9I
 Amn5ePOv0EfLN.ABuxLNVfz9IArIUi8nPr3GTz6dzjDGuLxpXl4rk_njTwew
 B3M7x_MDLF98q2acZ.kKR2ZPdEUBx9N0sOCe1TcUDQ2HP6z5l18XKMgc9.nY
 g5GEByZX38eJThFOoecd8SfGaAbRAVIDj6UHbiWYMYw9uRSq_wIJD2Yrjj2l
 Z_fZga9X2NtjkLOewrob9hnMaEsA82CzvyvBW.9sT8Q--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Daniel Santos <daniel.santos@pobox.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v5 3/25] compiler-gcc.h: Add gcc-recommended GCC_VERSION macro
Date: Tue, 25 Sep 2012 18:30:16 -0500
Message-Id: <1348615816-10061-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
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
1.7.3.4

