Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab0CRJJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:09:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60065 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0CRJHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:07:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=co27ZKPcnx3/uN/QXbNbFGXKR5DQ8Fh4C6WnKN1rUlHZK03wDLIzdouMrYWeFnDMM3
         fM/351NIcrMdLGsWdA749gmZtDjmaZgg45cUXtj2bczwFYLyH6wPBXqzfKglSvLZVnMh
         FNNFebxOW1R6I0/o1xZWcsTC7fszO9f5HsnRs=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/12] topology: convert cpu notifier to return encapsulate errno value
Date: Thu, 18 Mar 2010 18:05:17 +0900
Message-Id: <1268903124-10237-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the previous modification, the cpu notifier can return encapsulate
errno value. This converts the cpu notifiers for topology.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/topology.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index bf6b132..9fc630c 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -162,7 +162,7 @@ static int __cpuinit topology_cpu_callback(struct notifier_block *nfb,
 		topology_remove_dev(cpu);
 		break;
 	}
-	return rc ? NOTIFY_BAD : NOTIFY_OK;
+	return notifier_from_errno(rc);
 }
 
 static int __cpuinit topology_sysfs_init(void)
-- 
1.6.0.6

