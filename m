Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1HHNbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 09:31:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44256 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953Ab1HHNbi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 09:31:38 -0400
Subject: [PATCH] headers, sysctl: Add missing #include to <linux/sysctl.h>
 for userland
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 08 Aug 2011 14:31:36 +0100
Message-ID: <1312810296.2591.1155.camel@deadeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/sysctl.h> uses size_t, defined for userland by <stddef.h>.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/sysctl.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 11684d9..4c732b7 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -26,6 +26,10 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 
+#ifndef __KERNEL__
+#include <stddef.h>
+#endif
+
 struct completion;
 
 #define CTL_MAXNAME 10		/* how many path components do we allow in a
-- 
1.7.5.4


