Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab1JMAIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:08:54 -0400
Received: from claw.goop.org ([74.207.240.146]:47077 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab1JMAIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:08:51 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC V4 01/10] jump_label: use proper atomic_t initializer
Date: Wed, 12 Oct 2011 17:08:32 -0700
Message-Id: <133adee3846e281d68cb7c2a03294af2e6fb73c6.1318464413.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1318464413.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1318464413.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

ATOMIC_INIT() is the proper thing to use.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/jump_label.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 66f23dc..1213e9d 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -28,9 +28,9 @@ struct module;
 #ifdef HAVE_JUMP_LABEL
 
 #ifdef CONFIG_MODULES
-#define JUMP_LABEL_INIT {{ 0 }, NULL, NULL}
+#define JUMP_LABEL_INIT {ATOMIC_INIT(0), NULL, NULL}
 #else
-#define JUMP_LABEL_INIT {{ 0 }, NULL}
+#define JUMP_LABEL_INIT {ATOMIC_INIT(0), NULL}
 #endif
 
 static __always_inline bool static_branch(struct jump_label_key *key)
-- 
1.7.6.4

