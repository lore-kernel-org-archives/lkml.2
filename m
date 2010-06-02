Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab0FBIxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:53:22 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:59178 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0FBIxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:53:19 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: rjw@sisk.pl
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 8/9] PM / Hibernate: dealign swsusp_info
Date: Wed,  2 Jun 2010 10:52:47 +0200
Message-Id: <1275468768-28229-8-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Now there is no need to have swsusp_info page aligned thanks to chunk
i/o support. We may add more info after it on the very same page.
Later...

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/power.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 6e2e796..1fdbfe7 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -12,7 +12,7 @@ struct swsusp_info {
 	unsigned long		image_pages;
 	unsigned long		pages;
 	unsigned long		size;
-} __attribute__((aligned(PAGE_SIZE)));
+};
 
 #ifdef CONFIG_HIBERNATION
 #ifdef CONFIG_ARCH_HIBERNATION_HEADER
-- 
1.7.1


