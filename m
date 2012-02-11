Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab2BKToX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 14:44:23 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:52718 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2BKToV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 14:44:21 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 02/13] firewire: Add EXPORT_SYMBOL_GPL(fw_card_release)
Date: Sat, 11 Feb 2012 19:44:01 +0000
Message-Id: <1328989452-20921-3-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1328989452-20921-1-git-send-email-bootc@bootc.net>
References: <4E4BD560.4010806@bootc.net>
 <1328989452-20921-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firewire-sbp-target module requires this so it can keep a reference
to the fw_card object in order that it can fetch ORBs to execute and
read/write related data and status information.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/firewire/core-card.c b/drivers/firewire/core-card.c
index 85661b0..42b180b 100644
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -654,6 +654,7 @@ void fw_card_release(struct kref *kref)
 
 	complete(&card->done);
 }
+EXPORT_SYMBOL_GPL(fw_card_release);
 
 void fw_core_remove_card(struct fw_card *card)
 {
-- 
1.7.9

