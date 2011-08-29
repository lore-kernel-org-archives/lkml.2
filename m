Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab1H2QEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:04:25 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:34792 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839Ab1H2QET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:04:19 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Christoph Lameter <cl@linux.com>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/9] um: disable CMPXCHG_DOUBLE as it breaks UML build
Date: Mon, 29 Aug 2011 18:03:54 +0200
Message-Id: <1314633842-24515-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314633842-24515-1-git-send-email-richard@nod.at>
References: <1314633842-24515-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Commit b789ef518b2a7231b0668c813f677cee528a9d3f tests for cmpxchg_double
support in the SLUB code and it breaks UML builds with SLUB. Since UML
does not support checking for CPU features, disable CMPXCHG_DOUBLE just
like CMPXCHG_LOCAL is disabled for UML.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/Kconfig.x86 |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/um/Kconfig.x86 b/arch/um/Kconfig.x86
index d31ecf3..21bebe6 100644
--- a/arch/um/Kconfig.x86
+++ b/arch/um/Kconfig.x86
@@ -10,6 +10,10 @@ config CMPXCHG_LOCAL
 	bool
 	default n
 
+config CMPXCHG_DOUBLE
+	bool
+	default n
+
 source "arch/x86/Kconfig.cpu"
 
 endmenu
-- 
1.7.6.1

