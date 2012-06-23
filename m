Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2FWEIW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:08:22 -0400
Received: from nm1-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.27]:46813
	"HELO nm1-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757145Ab2FWEIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:08:18 -0400
X-Yahoo-Newman-Id: 40179.55476.bm@smtp103.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Tla93nAVM1kgP_nlOl_h5ECxchGybcSkb9z9nB3YfGyVEAe
 hoNJPrqFAIQHALNQ_K1OwiFo5PXNyUtDNYSblW7faSJYizwXxVO94AfMXK.H
 VYY1JB1clbAGi109yBYREO0tDRTrpFxiMaxXseiBV1orj6fagAvnQQXrbpsh
 HYoItKKyRPO1fqJREZVblG7.AIg9MzSJLkDSUK2BeDy21R.zidwD5t49N2B6
 zb__quXNE7N2iKhrTJe75kBIgUpsMW4WpbJNefY6FRI6xCJv0cIlXMb4t0zT
 _4aZQW.JovwQRSIpdBK2t1M_IatXok.CZknUfEV8IacVpT1h4iSWwq02m9vr
 K0o1g5hPvAv2Ikqbe2fC8ISFTTsFx08_kBWBtvyc7DSNnCI8hWhUupt2p1IC
 9Bk0fnry10a4aKBELYacIT0xjahwY2kwPYrk-
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
Subject: [PATCH v4 1/13] compiler-gcc4.h: Correct verion check for __compiletime_error
Date: Fri, 22 Jun 2012 23:00:36 -0500
Message-Id: <1340424048-7759-2-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
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

