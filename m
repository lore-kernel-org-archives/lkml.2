Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab2KMWQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:16:03 -0500
Received: from nm9-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.249]:26419
	"EHLO nm9-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754218Ab2KMWNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:13:52 -0500
X-Yahoo-Newman-Id: 567578.28409.bm@smtp115.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: b6WkN3MVM1ne16pKHj.lnAwgJvLL5czmPeIM1WNp1q_VXbQ
 gx50_c.gfW73XosNQ59pcswGBE_TGelPgKN97T4xMxIGGCroi9uLAa.DgEo7
 Fr9zbGVrKRpKDFl4WLCsFnQiv3A9zQIMCwxxbTnf79lNQDomMM7RceEsqRzY
 uyQsdwjTeGoKyyR1Y42uhRAqXAlBmelEKDI0XhvGPo6fieQJz2Kcbv3vh5f0
 jUiTNJjgRklIpGvFs7XKc2JBXG995.QAjOHJJPXKyyiyst4o4jiyMn..fA61
 K8dCgugkfKvS6QI2ZngB739CKboVC6GQIv9TqtHbY1qKlvrOsb5gAzqwI9wC
 fafxK3fU6wDLMVcpQRKCMuKn.041DMz18j9cpHdgBZTjwCCc32aBojztq66f
 tZow4G3RDryS95U96uqRbWvzCpIgiui4A6zZKlFFE0d.USC9lTkmOAIJTOkG
 3XxRtKK3KCdQAi6ATF17R8JNIvib55qzuz8pF4e9Ox3C3hXyLOZcss3ULtEE
 fP1mCxUAw1bBU4l5oEinqHuiUrLe5SmismakSpyixPnA-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v5 2/9] compiler-gcc.h: Add gcc-recommended GCC_VERSION macro
Date: Tue, 13 Nov 2012 16:13:34 -0600
Message-Id: <1352844821-18952-2-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
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

