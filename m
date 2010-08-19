Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0HSR0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 13:26:12 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:46794 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751991Ab0HSR0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 13:26:10 -0400
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: linux-kernel@vger.kernel.org
Cc: Hagen Paul Pfeifer <hagen@jauu.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] kernel.h: add {min,max}3 macros
Date: Thu, 19 Aug 2010 19:18:18 +0200
Message-Id: <1282238299-28315-1-git-send-email-hagen@jauu.net>
X-Mailer: git-send-email 1.7.2.1.95.g3d045.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce two additional min/max macros to compare three operands.
This will save some cycles as well as some bytes on the stack and last
but not least more pleasing as macro nesting.

Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/kernel.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2b0a35e..9a9b52c 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -640,6 +640,22 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
+#define min3(x, y, z) ({			\
+	typeof(x) _min1 = (x);			\
+	typeof(y) _min2 = (y);			\
+	typeof(z) _min3 = (z);			\
+	(void) (&_min1 == &_min2 == &_min3);	\
+	_min1 < _min2 ? (_min1 < _min3 ? _min1 : _min3) : \
+		(_min2 < _min3 ? _min2 : _min3); })
+
+#define max3(x, y, z) ({			\
+	typeof(x) _max1 = (x);			\
+	typeof(y) _max2 = (y);			\
+	typeof(z) _max3 = (z);			\
+	(void) (&_max1 == &_max2 == &_max3);	\
+	_max1 > _max2 ? (_max1 > _max3 ? _max1 : _max3) : \
+		(_max2 > _max3 ? _max2 : _max3); })
+
 /**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value
-- 
1.7.2.1.95.g3d045.dirty

