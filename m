Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2JGXXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:23:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38642 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754627Ab2JGXXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:19 -0400
Message-Id: <20121007225839.973788370@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 038/108] HID: logitech: fix mask to enable DJ mode
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nestor Lopez Casado <nlopezcasad@logitech.com>

commit 765031668fb2b064aebd9a568e5ad794cbe3413a upstream.

The user can only experience the bug if she pairs 6 devices to a Unifying
receiver. The sixth paired device would not work.

The value changed is actually a bitmask that enables reporting from each
paired device. As the sixth bit was not set, the sixth device reports are
ignored by the receiver and never get to the driver.

Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>

 drivers/hid/hid-logitech-dj.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-logitech-dj.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 38b12e4..2b56efc 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -445,7 +445,7 @@ static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 	dj_report.report_id = REPORT_ID_DJ_SHORT;
 	dj_report.device_index = 0xFF;
 	dj_report.report_type = REPORT_TYPE_CMD_SWITCH;
-	dj_report.report_params[CMD_SWITCH_PARAM_DEVBITFIELD] = 0x1F;
+	dj_report.report_params[CMD_SWITCH_PARAM_DEVBITFIELD] = 0x3F;
 	dj_report.report_params[CMD_SWITCH_PARAM_TIMEOUT_SECONDS] = (u8)timeout;
 	return logi_dj_recv_send_report(djrcv_dev, &dj_report);
 }


