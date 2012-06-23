Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2FWEHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:07:51 -0400
Received: from nm27-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.227]:20826
	"HELO nm27-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755209Ab2FWEHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:07:48 -0400
X-Yahoo-Newman-Id: 578250.55476.bm@smtp103.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ctXFlIEVM1mdU9j6r8WT4zsagkAOUj6k7D6fIsf0MRR3GbK
 ZfQtgjm7ovgoKJYiQxmUzUJfy9fOsKrB4hARqJytck.jum.Ygw9HHdwz7jHu
 tx.qCSgtiuXnxY6thfxqs12Vqf1JNoJq7bnC73XHv7ededj7UWwUG8gzFDPI
 BjHGw4MuV_oT7qjP4nuv0yq8VQnNX7XjwUsZtb7k2wSlyx8T.YU6owOpgJ._
 279PgVnOufY.4suZ8uGCfSW.5qc6rsHBB1qSbCtm7WWWZdFuYRPJmxTuNEkQ
 5yBKMoewN_g6U5H0xDRTwhevPExwlAcAe43WvWhYK5SSLHVxIkmkkEHfDTGh
 udfCVrewqhpHt6ciVJnBf4wlwf3i3J7rqgXYunC7CKmXnOqfBkE26RQn5UP8
 xB.f7kPHhTnoRNhkKdYjFCKwO_3KoaKiUvsjfHitHSTACciz081KimBF_Oh9
 Ev3isyyM0cYHSv1RegbBzDV42HUWJgvdad7T2ywspgDhkD7STgTeJ5TLW0La
 FknmdCqjR.nJ5UG5_VUPtqHwdw6RWYTuQzNpMyJxVRGs2KvddyMEovXKhubS
 1dwZOHw5C.5ZRO7Mt87qqqWhUddKrBVlSydo-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v4 3/13] compiler-gcc.h: Add gcc-recommended GCC_VERSION macro
Date: Fri, 22 Jun 2012 23:00:38 -0500
Message-Id: <1340424048-7759-4-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
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
index e5834aa..7970e31 100644
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

