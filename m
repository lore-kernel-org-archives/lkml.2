Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422792Ab2KNMpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 07:45:47 -0500
Received: from masquerade.micron.com ([137.201.242.130]:26132 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422757Ab2KNMpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 07:45:46 -0500
Message-ID: <50A399B3.5060806@micron.com>
Date: Wed, 14 Nov 2012 06:16:35 -0700
From: Selvan Mani <smani@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <axboe@kernel.dk>
CC: <sbradshaw@micron.com>, <asamymuthupa@micron.com>,
        <linux-kernel@vger.kernel.org>
Subject: mtip32xx: Fix padding issue
References: <50A397DD.4060207@micron.com>
In-Reply-To: <50A397DD.4060207@micron.com>
X-Forwarded-Message-Id: <50A397DD.4060207@micron.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19364.001
X-TM-AS-Result: No--6.207800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Another tiny patch.

Removed __packed before the struct smart_attr and added __packed at end of 
the structure to fix padding issue.

Signed-off-by: Selvan Mani  <smani@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 5f4a917..1e5b1d3 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -155,14 +155,14 @@ enum {
 	MTIP_DDF_REBUILD_FAILED_BIT = 8,
 };
 
-__packed struct smart_attr{
+struct smart_attr {
 	u8 attr_id;
 	u16 flags;
 	u8 cur;
 	u8 worst;
 	u32 data;
 	u8 res[3];
-};
+} __packed;
 
 /* Register Frame Information Structure (FIS), host to device. */
 struct host_to_dev_fis {
-- 
1.7.1


