Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab2JETn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:43:29 -0400
Received: from nm39-vm2.bullet.mail.bf1.yahoo.com ([72.30.239.146]:42414 "EHLO
	nm39-vm2.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754609Ab2JETnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:43:24 -0400
X-Yahoo-Newman-Id: 702828.55233.bm@omp1012.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: JcnYbFEVM1nbjWB9GKF.zeffP97x5ermyO6ZjXGzB8.F6RC
 9aDuiBipME771vZk6Pu75qamDdAhkukHqnAi_gGmeavn_CVQPQzNsea.TxKd
 _9hWm_PgrBDypycA0BSURwV5.6Z4zGJYzdYgy3cwrGLxvTmAb_5lsJR._hUk
 CPc0_kXu2Oj.8ia8vWpR3HXUU.Mqk6K_TTVEJ0ob22gkyst.OnOzw0b7LveZ
 3Ai_vGLVHI1hVz9qonW8yk1ZsLZfB4ISrA_59kSTLqU9WHpwm7ZUr_BY1i10
 1..ov0HlGSqLneJBlowSTutWdNm4YA6U5XC9Kqp7dbV1w3xqqxGSxiBtf6Db
 Xj_OFMBBUFE.bFOjLDbm0SSiptz6e6MfClzOkRQ3C65ciHdTJSoBF_7kTBQR
 aboEcxJA8Wlh3wWV_m62tIycAJMRzln1vEyATl6xAcXwE2VNIQd9J
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
Subject: [PATCH v2 04/10] bug.h: directly include linux/compiler.h
Date: Fri,  5 Oct 2012 14:42:43 -0500
Message-Id: <1349466169-20637-4-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are just including asm/bug.h and expecting that linux/compiler.h will
eventually be included to define __linktime_error (used in
BUILD_BUG_ON). This patch includes it directly for clarity and to avoid
the possibility of changes in <arch>/*/include/asm/bug.h being changed
or not including linux/compiler.h for some reason. (Later patches will
in this set use more macros defined in compiler*.h.)

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index aaac4bb..4bd74d8 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -2,6 +2,7 @@
 #define _LINUX_BUG_H
 
 #include <asm/bug.h>
+#include <linux/compiler.h>
 
 enum bug_trap_type {
 	BUG_TRAP_TYPE_NONE = 0,
-- 
1.7.3.4

