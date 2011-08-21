Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1HUMNk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 08:13:40 -0400
Received: from www17.your-server.de ([213.133.104.17]:51229 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1HUMNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 08:13:39 -0400
Subject: [PATCH] check for get/put_cpu() imbalances
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <julia@diku.dk>
Date: Sun, 21 Aug 2011 14:12:54 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313928777.18505.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

Semantic patch that checks if every get_cpu() has a corresponding put_cpu().

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---
 scripts/coccinelle/misc/getput_cpu.cocci |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/misc/getput_cpu.cocci

diff --git a/scripts/coccinelle/misc/getput_cpu.cocci b/scripts/coccinelle/misc/getput_cpu.cocci
new file mode 100644
index 0000000..8f76153
--- /dev/null
+++ b/scripts/coccinelle/misc/getput_cpu.cocci
@@ -0,0 +1,24 @@
+/// Check for get/put_cpu() imbalances
+///
+// Confidence: Low
+// Copyright: (C) 2011 Thomas Meyer
+// URL:
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual report
+
+@r1 depends on report@
+position p;
+@@
+
+* get_cpu()@p
+... when != put_cpu()
+? get_cpu()
+
+@script:python depends on report@
+p << r1.p;
+@@
+
+msg="WARNING: Possible missing put_cpu()!"
+coccilib.report.print_report(p[0], msg)
-- 
1.7.6


