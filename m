Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab0CWQXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:23:20 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:51599 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab0CWQXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:23:18 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Mar 2010 12:23:18 EDT
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFC 14/15] PM / Hibernate: dealign swsusp_info
Date: Tue, 23 Mar 2010 17:17:42 +0100
Message-Id: <1269361063-3341-14-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Now there is no need to have swsusp_info page aligned thanks to chunk
i/o support. We may add more info after it on the very same page.
Later...

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/power.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 842d27b..cf1450f 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -13,7 +13,7 @@ struct swsusp_info {
 	unsigned long		image_pages;
 	unsigned long		pages;
 	unsigned long		size;
-} __attribute__((aligned(PAGE_SIZE)));
+};
 
 #ifdef CONFIG_HIBERNATION
 #ifdef CONFIG_ARCH_HIBERNATION_HEADER
-- 
1.7.0.2


