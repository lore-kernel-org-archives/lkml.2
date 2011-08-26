Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab1HZUeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:34:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab1HZUeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:34:12 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/13] base/devres.c: quiet sparse noise about context imbalance
Date: Fri, 26 Aug 2011 13:33:46 -0700
Message-Id: <1314390834-3411-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314390834-3411-1-git-send-email-gregkh@suse.de>
References: <20110826191130.GA5557@kroah.com>
 <1314390834-3411-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hartleys@visionengravers.com>

devres_release_all and devres_release_group both aquire the lock
&dev->devres_lock but the release of that lock is done in release_nodes.
This results in sparse noise about context imbalance.

Add a lock annotation to release_nodes to quiet this noise.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/devres.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index cf7a0c7..65cd748 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -397,6 +397,7 @@ static int remove_nodes(struct device *dev,
 
 static int release_nodes(struct device *dev, struct list_head *first,
 			 struct list_head *end, unsigned long flags)
+	__releases(&dev->devres_lock)
 {
 	LIST_HEAD(todo);
 	int cnt;
-- 
1.7.6.1

