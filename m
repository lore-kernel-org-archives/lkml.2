Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413Ab1LPSZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:25:46 -0500
Received: from mail-yw0-f74.google.com ([209.85.213.74]:55154 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760133Ab1LPSZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:25:40 -0500
From: David Decotigny <decot@googlers.com>
To: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <martinez.javier@gmail.com>,
        Robin Getz <rgetz@blackfin.uclinux.org>,
        Matt Mackall <mpm@selenic.com>, David Decotigny <decot@googlers.com>
Subject: [PATCH net-next v1 1/6] tg3: fix possible infinite loop
Date: Fri, 16 Dec 2011 10:19:44 -0800
Message-Id: <077140640823965d09baa7f61b26c7ba9c1b6e68.1324059527.git.decot@googlers.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1324059527.git.decot@googlers.com>
References: <cover.1324059527.git.decot@googlers.com>
In-Reply-To: <cover.1324059527.git.decot@googlers.com>
References: <cover.1324059527.git.decot@googlers.com>
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found by browsing the code.

Tested:
  Not tested along the affected path. No regression observed.



Signed-off-by: David Decotigny <decot@googlers.com>
---
 drivers/net/ethernet/broadcom/tg3.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 8bf11ca..e04c4f9 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -13877,8 +13877,10 @@ static int __devinit tg3_get_invariants(struct tg3 *tp)
 				continue;
 			}
 			if (pci_id->rev != PCI_ANY_ID) {
-				if (bridge->revision > pci_id->rev)
+				if (bridge->revision > pci_id->rev) {
+					pci_id++;
 					continue;
+				}
 			}
 			if (bridge->subordinate &&
 			    (bridge->subordinate->number ==
-- 
1.7.3.1

