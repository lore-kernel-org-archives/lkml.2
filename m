Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab2JETnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:43:21 -0400
Received: from nm14.bullet.mail.ac4.yahoo.com ([98.139.52.211]:21890 "HELO
	nm14.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754408Ab2JETnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:43:14 -0400
X-Yahoo-Newman-Id: 383658.71608.bm@omp1013.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: .WSb_2EVM1lLqW23AboUyfK4rrih30NtdYinw7t2Cbm_Ma3
 tt9YrCjzHaS2a.z.waZgaIbADxg2PwxH9hSYgtRMb_thOTo24_bgw6avEYEk
 yHHnrJ1CQBdlU_zp58M8PwoCfjmUrFiOxdW5JVvcWZk5wHbn0tznTvoD1nEi
 NswIw_RFgseuV8i..GcxBwQ8CikVluZLRjg6JF8CpToKJPftcvL48PaOA5Ze
 CCiahd5u.fC0nkms6O026OE8WhEF7b27agdZ4ecYLBAqYJKVB6KKJfKDdcvp
 N5ioGPnTiDKswXkg.VKvmrZoPR9RXmnQ_iZIQpVcm5HZ1G34uHa6pOZtmgu8
 L2yQMM.D0PByME08InH7m7xhoKTNvG0LQRpOf5Ddv7n9bJSKPIgwajwOiMCJ
 RoI3Q5x.Zk.KvMg12844kZHa5EbNtzzr3HrhHcHj_MWpV2jD1vP938XBbKB4
 33Q4eIQWzdyOoiG7UIRkLdpq_ExpZHArtBknW9y6vfqWvQJMCC8uAnbAfisY
 fJwuXe3o4pMyj.jGRvpTsmVAe_EquD5FZ4cj5sJeSsVo-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v2 02/10] compiler-gcc.h: Add gcc-recommended GCC_VERSION macro
Date: Fri,  5 Oct 2012 14:42:41 -0500
Message-Id: <1349466169-20637-2-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
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
1.7.3.4

