Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0JVHXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:23:33 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:37633 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab0JVHXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:23:32 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: [PATCH 05/30] staging/vme: fix bogus clearing of the bus number in vme_free_bus_num
Date: Fri, 22 Oct 2010 02:36:27 -0400
Message-Id: <1287729412-24356-6-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/vme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 9fa0609..afd2dbd 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -1348,7 +1348,7 @@ static int vme_alloc_bus_num(int *bus)
 static void vme_free_bus_num(int bus)
 {
 	mutex_lock(&vme_bus_num_mtx);
-	vme_bus_numbers |= ~(0x1 << bus);
+	vme_bus_numbers &= ~(0x1 << bus);
 	mutex_unlock(&vme_bus_num_mtx);
 }
 
-- 
1.7.1

