Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab2IYX3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:29:30 -0400
Received: from nm19-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.216]:27351 "HELO
	nm19-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751732Ab2IYX33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:29:29 -0400
X-Yahoo-Newman-Id: 599507.61732.bm@omp1009.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: b2pV5mgVM1km1bqDDhOQsFCY.pXDOVvHKBRZ3J604dRDCS3
 U9hdtC7xAWU0j_S3zXRTxcpBzfLU_QSpxBBs33yQ_21qYOq8QJwnwCXXzTrI
 naJKfvg.nAczOa2uUpQG82mAY.FBkthnjQxv3nmf6gc038Aunbmzeuhr40y3
 blvCkdi3Gw_bot9Sz26X3UozlOZ2CQC1lpd22AvQfGdS5S1JVVMAb7_NnmkK
 nzxtFiP1r_umsEVxQWu7GpEuiMxzlhoE30D.qAjQOUxl_7U.92730kvdJeux
 M_FjBFv5egsDswW5tyOe_aWai1nwVExuYm.QPO9YsU0dHGuIsOPG9xrcoxNS
 iNOxJ7wEZlr56Bp6bfWY0ITMRsf3GSqMfVSBcGnT9vgsyGMvdESvbRtk4iiN
 lR4mDmu4FyB2c_pIrwZCNA8bhq6Va87MMBJekPfa9XaVJCHqGOl5R
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Daniel Santos <daniel.santos@pobox.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v5 1/25] compiler-gcc4.h: Correct verion check for __compiletime_error
Date: Tue, 25 Sep 2012 18:29:18 -0500
Message-Id: <1348615758-9979-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__attribute__((error(msg))) was introduced in gcc 4.3 (not 4.4) and as I
was unable to find any gcc bugs pertaining to it, I'm presuming that it
has functioned as advertised since 4.3.0.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/compiler-gcc4.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 2f40791..10ce4fa 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -52,7 +52,7 @@
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

