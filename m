Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab2J1X2W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:28:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42155 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756934Ab2J1X2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:13 -0400
Message-Id: <20121028231552.159739105@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:25 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Piotr Haber <phaber@broadcom.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Arend Van Spriel <arend@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 049/105] bcma: fix unregistration of cores
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Haber <phaber@broadcom.com>

commit 1fffa905adffbf0d3767fc978ef09afb830275eb upstream.

When cores are unregistered, entries
need to be removed from cores list in a safe manner.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/bcma/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 432aeee..d865470 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -158,9 +158,10 @@ static int bcma_register_cores(struct bcma_bus *bus)
 
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


