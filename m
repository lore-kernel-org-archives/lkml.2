Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab1CGTeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:34:44 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:38813 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627Ab1CGTen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:34:43 -0500
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] staging/hv: add missing include causing build error
Date: Mon,  7 Mar 2011 20:34:30 +0100
Message-Id: <1299526470-8988-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20110307180547.0cd7b9eb.sfr@canb.auug.org.au>
References: <20110307180547.0cd7b9eb.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes following build error:

In file included from drivers/staging/hv/channel.h:28,
                 from drivers/staging/hv/vmbus_private.h:30,
                 from drivers/staging/hv/hv.c:28:
drivers/staging/hv/channel_mgmt.h:234: error: field ‘work’ has incomplete type

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---

Found with randconfig on x86.

 drivers/staging/hv/channel_mgmt.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.h b/drivers/staging/hv/channel_mgmt.h
index 3368bf1..96f74e2 100644
--- a/drivers/staging/hv/channel_mgmt.h
+++ b/drivers/staging/hv/channel_mgmt.h
@@ -27,6 +27,7 @@
 
 #include <linux/list.h>
 #include <linux/timer.h>
+#include <linux/workqueue.h>
 #include "ring_buffer.h"
 #include "vmbus_channel_interface.h"
 #include "vmbus_packet_format.h"
-- 
1.7.0.4

