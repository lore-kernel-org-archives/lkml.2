Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0H1M57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 08:57:59 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:42590 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192Ab0H1M56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 08:57:58 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-17.arcor-online.net 9252CCBE60
Subject: [PATCH] HID: roccat: Fixing race condition on initialization
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Aug 2010 14:57:48 +0200
Message-ID: <1283000268.4789.1.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed raced condition where event occurs before drvdata is set.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kone.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index f776957..cfeab56 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -966,6 +966,10 @@ static int kone_raw_event(struct hid_device *hdev, struct hid_report *report,
 	struct kone_device *kone = hid_get_drvdata(hdev);
 	struct kone_mouse_event *event = (struct kone_mouse_event *)data;
 
+	/* possible race condition on initialization */
+	if (!kone)
+		return 0;
+
 	/* keyboard events are always processed by default handler */
 	if (size != sizeof(struct kone_mouse_event))
 		return 0;
-- 
1.7.2.2



