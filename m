Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1BWNZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:25:59 -0500
Received: from cernmx30.cern.ch ([137.138.144.177]:30204 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab1BWNZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:25:47 -0500
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <wfp5p@virginia.edu>, <cota@braap.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 2/2] staging: vme: fix loop condition
Date: Wed, 23 Feb 2011 14:25:28 +0100
Message-ID: <1298467528-26472-3-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298467528-26472-1-git-send-email-manohar.vanga@cern.ch>
References: <1298467528-26472-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix loop condition in vme_register_bridge that results in an infinite
loop in the event that device_register fails.

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/vme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 88bf455..c1ec230 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -1364,7 +1364,7 @@ int vme_register_bridge(struct vme_bridge *bridge)
 	return retval;
 
 err_reg:
-	while (i > -1) {
+	while (--i >= 0) {
 		dev = &bridge->dev[i];
 		device_unregister(dev);
 	}
-- 
1.7.1

