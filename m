Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935270Ab2JXQkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:40:10 -0400
Received: from nm20-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.174]:25166
	"EHLO nm20-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932967Ab2JXQkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:40:02 -0400
X-Yahoo-Newman-Id: 347829.79197.bm@smtp105.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: uowUZfYVM1nD.rBUs7RqqYLxYJOTo8Oj4bTFMJrX1kz22iR
 JFniSFQX5bGu_Ksu3359rJphAQMSzfxQ3psJ_THPV4aRRn6eqfmIdyr_vEwy
 .Eh0pY.l1jKAyxe81kipJ5Im2dzDjh1I_7Ur23Slueh9flp.DhyoBiZJMgQq
 FbuIKo55aLkX3.HQ0YR.BH..W.cq02ZF6inE_0dFwKgXayhTSnDDHxu7xBr3
 o1fM0iFPnnX1TLKYV4GEjaJeEiic4lb_DPgAmSD3gg.xAvbQ2McjRAiQd8KB
 lPzBesm.NlOcUEN4NKop2NER2TgmFZ.Hh9A93ouLPiPltDCJMbIgHFWQ9kw4
 hDVcg93eNRgnOa2zt6URfbuf7vMrWNhxIxt66zhQeKWb85rSrPJmYjcmWMN4
 hiHlDOGkUqkt0AgXUT0iOFmBp4YmEZPZO1aEZl8Mbug6wyEZbmPFW
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v3 08/10] bug.h: Fix BUILD_BUG_ON macro in __CHECKER__
Date: Wed, 24 Oct 2012 11:33:59 -0500
Message-Id: <1351096441-12388-8-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
References: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When __CHECKER__ is defined, we disable all of the BUILD_BUG.* macros.
However, BUILD_BUG_ON was evaluating to nothing in this case, and we
want (0) since this is a function-like macro that will be followed by a
semicolon.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index f8eae31..1b43ea2 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -16,7 +16,7 @@ struct pt_regs;
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
 #define BUILD_BUG_ON_ZERO(e) (0)
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
-#define BUILD_BUG_ON(condition)
+#define BUILD_BUG_ON(condition) (0)
 #define BUILD_BUG() (0)
 #else /* __CHECKER__ */
 
-- 
1.7.3.4

