Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab1G1FSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 01:18:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:51305 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab1G1FQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 01:16:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 02/11] sysdev.h: dont include <linux/module.h> for no reason
Date: Thu, 28 Jul 2011 01:16:09 -0400
Message-Id: <1311830178-30314-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The <linux/module.h> pretty much brings in the kitchen sink along
with it, so it should be avoided wherever reasonably possible in
terms of being included from other commonly used <linux/something.h>
files, as it results in a measureable increase on compile times.

There doesn't appear to be any module specifics in this file.
The obvious people who were relying on the presence of
the vast amount of stuff module.h sucked in have been fixed.

If other files are implicitly relying on it, then lets see who
they are and fix them too.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/sysdev.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/sysdev.h b/include/linux/sysdev.h
index d35e783..20f63d3 100644
--- a/include/linux/sysdev.h
+++ b/include/linux/sysdev.h
@@ -22,7 +22,6 @@
 #define _SYSDEV_H_
 
 #include <linux/kobject.h>
-#include <linux/module.h>
 #include <linux/pm.h>
 
 
-- 
1.7.6

