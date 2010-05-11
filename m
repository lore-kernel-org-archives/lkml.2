Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab0EKC53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 22:57:29 -0400
Received: from sh.osrg.net ([192.16.179.4]:46178 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758130Ab0EKC5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 22:57:14 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH -mm 1/3] Documentation: add SCSI drivers' mapping error handling to DMA-API-HOWTO
Date: Tue, 11 May 2010 11:55:27 +0900
Message-Id: <1273546529-16846-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 11 May 2010 11:56:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds the concrete DMA mapping error handling for SCSI drivers on the
queuecommand path.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 Documentation/DMA-API-HOWTO.txt |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index 93d9087..a38ddad 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -745,6 +745,10 @@ and return NETDEV_TX_OK if the DMA mapping fails on the transmit hook
 (ndo_start_xmit). This means that the socket buffer is just dropped in
 the failure case.
 
+SCSI drivers must return SCSI_MLQUEUE_HOST_BUSY if the DMA mapping
+fails in the queuecommand hook. This means that the SCSI subsystem
+passes the command to the driver again later.
+
 			   Closing
 
 This document, and the API itself, would not be in its current
-- 
1.6.5

