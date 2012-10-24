Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2JXQku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:40:50 -0400
Received: from nm25-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.184]:36933
	"EHLO nm25-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752875Ab2JXQks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:40:48 -0400
X-Yahoo-Newman-Id: 997213.79197.bm@smtp105.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HHAwkiQVM1kyoW_fwfFbeCXieIsPTHRwR0KN8xRTeWngQ6W
 Kzzo5bVfMrN5BwGV86gc6aamPmalZfkAF.UL7mW.zPOMGVg8WOJmNrWiqKAs
 U4Yw3YmcrxwthdP_B85wrIM7KsbTjQRhGNFX9rrV.roCuaUcey9v5OehLXbi
 pMzrK89QYgFuYJgYdnFUdMLp_BFKE6mQsh0nh5FrI8Nu994GfEm3JKZ5yUsg
 Uxhv_3IP_5hou42jBJCwJyHfzUN1Eaqoi05GHlwvNZRK5b1Ed62yKhuhw.__
 hDOlu2n4mJVSjAhrrPy087M2F1ilYmSlCW5xiNkPjfgcTXTfYtXwLXXHzico
 LQAttXBjl.pg7H.SAEbtrwvXxhgFleiYFGMfRd7pavGE3sJgEhggE6CjgJrT
 rLk5QAvShoEpMR_YqmQh.vPaEM1IumIeiLnjq71ulT0hsWvMaEg84iuITlTk
 ZZc.6S6047mxjHG14twrZYg7kmR3Q
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
Subject: [PATCH v3 04/10] bug.h: directly include linux/compiler.h
Date: Wed, 24 Oct 2012 11:33:55 -0500
Message-Id: <1351096441-12388-4-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
References: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we are only including asm/bug.h and then expecting that
linux/compiler.h will eventually be included to define __linktime_error
(used in BUILD_BUG_ON). This patch includes it directly for clarity and
to avoid the possibility of changes in <arch>/*/include/asm/bug.h being
changed or not including linux/compiler.h for some reason. (Later
patches will in this set use more macros defined in compiler*.h.)

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

