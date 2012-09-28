Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab2I1XUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:20:51 -0400
Received: from nm37-vm3.bullet.mail.ne1.yahoo.com ([98.138.229.131]:35564 "HELO
	nm37-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758797Ab2I1XUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:20:47 -0400
X-Yahoo-Newman-Id: 395920.31449.bm@omp1030.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3DaOHogVM1mca.JPPSG3u0RksCHJvMf2MFmpbPU2kcjNdl6
 LjOp1wa9s6glgWRRhVPigUn2buexHWS09IP.yuU.JuEcMEyq4NYpal9qh1zs
 3G2JhqODaJ1vZ7LxS1_ml2pPaX2PZA_SLXkpHGntS9bwi3bk6O8mY5KQJRIN
 0pH88GI_87CtC8IXntKrClNOFb3I81eAn4_cKCsGl27N7JxgmkhzyF5In_MM
 Hwo85hhmqYPRekN_cpLqXKLqslbPiIHskCIPdzWuXVLB8XfsSxGqbs3sIRxn
 qjgwOVnudbzmBj61nV75uv.zaas2RkpYlE2lHUyhjP.HtJmIW6YLM.CSOWAs
 so1d3qrEgg1TazKBUxT3UrOiO2sd9bUxbRgBix.S.8aGP6jkr.zWkbuhZRcO
 L1Pztjs6K4uh0mYK6xZK9Ns9BLjQ7gy_m2cfYmghnEOhOSpI4gkQSNs6jGxI
 4TujWhLI-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Marek <mmarek@suse.cz>
Subject: [PATCH 1/10] compiler-gcc4.h: correct verion check for __compiletime_error
Date: Fri, 28 Sep 2012 18:20:02 -0500
Message-Id: <1348874411-28288-2-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE: this is has already been comitted to -mm

__attribute__((error(msg))) was introduced in gcc 4.3 (not 4.4) and as I
was unable to find any gcc bugs pertaining to it, I'm presuming that it
has functioned as advertised since 4.3.0.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/compiler-gcc4.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 997fd8a..8721704 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -59,7 +59,7 @@
 #if __GNUC_MINOR__ > 0
 #define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
 #endif
-#if __GNUC_MINOR__ >= 4 && !defined(__CHECKER__)
+#if __GNUC_MINOR__ >= 3 && !defined(__CHECKER__)
 #define __compiletime_warning(message) __attribute__((warning(message)))
 #define __compiletime_error(message) __attribute__((error(message)))
 #endif
-- 
1.7.3.4

