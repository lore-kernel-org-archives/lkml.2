Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab0JZBRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:17:17 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:37273 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab0JZBL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:11:59 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>
Subject: [PATCH 05/30] staging/vme: fix bogus clearing of the bus number in vme_free_bus_num
Date: Mon, 25 Oct 2010 21:10:51 -0400
Message-Id: <1288055476-19438-6-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1288055476-19438-1-git-send-email-cota@braap.org>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
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

