Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664Ab2KZRLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:11:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47897 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab2KZRLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:11:32 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Piotr Haber <phaber@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 186/270] bcma: fix unregistration of cores
Date: Mon, 26 Nov 2012 14:57:56 -0200
Message-Id: <1353949160-26803-187-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Haber <phaber@broadcom.com>

commit 1fffa905adffbf0d3767fc978ef09afb830275eb upstream.

When cores are unregistered, entries
need to be removed from cores list in a safe manner.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/bcma/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 7e138ec..edb9233 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -131,9 +131,10 @@ static int bcma_register_cores(struct bcma_bus *bus)
 
 static void bcma_unregister_cores(struct bcma_bus *bus)
 {
-	struct bcma_device *core;
+	struct bcma_device *core, *tmp;
 
-	list_for_each_entry(core, &bus->cores, list) {
+	list_for_each_entry_safe(core, tmp, &bus->cores, list) {
+		list_del(&core->list);
 		if (core->dev_registered)
 			device_unregister(&core->dev);
 	}
-- 
1.7.9.5

