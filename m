Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab2DSMH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:07:27 -0400
Received: from smtp.nokia.com ([147.243.1.47]:17729 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005Ab2DSMGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:06:40 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linus.walleij@linaro.org, artem.bityutskiy@linux.intel.com,
        shubhrajyoti@ti.com
Subject: [PATCH 5/6] HSI: hsi_char: Remove max_data_size from sysfs
Date: Thu, 19 Apr 2012 15:05:26 +0300
Message-Id: <1334837127-12931-6-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
References: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove max_data_size sysfs entry. Otherwise is possible
to have a buffer overrun if its value is increased after
the device is open.

Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
---
 drivers/hsi/clients/hsi_char.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hsi/clients/hsi_char.c b/drivers/hsi/clients/hsi_char.c
index 88a050d..3ad91f6 100644
--- a/drivers/hsi/clients/hsi_char.c
+++ b/drivers/hsi/clients/hsi_char.c
@@ -123,7 +123,7 @@ struct hsc_client_data {
 static unsigned int hsc_major;
 /* Maximum buffer size that hsi_char will accept from userspace */
 static unsigned int max_data_size = 0x1000;
-module_param(max_data_size, uint, S_IRUSR | S_IWUSR);
+module_param(max_data_size, uint, 0);
 MODULE_PARM_DESC(max_data_size, "max read/write data size [4,8..65536] (^2)");
 
 static void hsc_add_tail(struct hsc_channel *channel, struct hsi_msg *msg,
-- 
1.7.5.4

