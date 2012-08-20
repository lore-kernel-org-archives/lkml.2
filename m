Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab2HTO2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:28:46 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53585 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab2HTO2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:28:41 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH RESEND] dj: memory scribble in logi_dj
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 20 Aug 2012 15:46:10 +0100
Message-ID: <20120820144554.6301.66896.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Allocate a structure not a pointer to it !

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/hid/hid-logitech-dj.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 0f9c146..4d524b5 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -439,7 +439,7 @@ static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv_dev)
 	struct dj_report *dj_report;
 	int retval;
 
-	dj_report = kzalloc(sizeof(dj_report), GFP_KERNEL);
+	dj_report = kzalloc(sizeof(struct dj_report), GFP_KERNEL);
 	if (!dj_report)
 		return -ENOMEM;
 	dj_report->report_id = REPORT_ID_DJ_SHORT;
@@ -456,7 +456,7 @@ static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 	struct dj_report *dj_report;
 	int retval;
 
-	dj_report = kzalloc(sizeof(dj_report), GFP_KERNEL);
+	dj_report = kzalloc(sizeof(struct dj_report), GFP_KERNEL);
 	if (!dj_report)
 		return -ENOMEM;
 	dj_report->report_id = REPORT_ID_DJ_SHORT;

