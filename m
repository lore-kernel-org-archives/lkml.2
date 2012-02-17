Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab2BQRr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:47:59 -0500
Received: from stats.peacock.arvixe.com ([174.122.104.67]:34077 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751410Ab2BQRr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:47:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer;
	b=J01bbmUA0cXbEwdguP+dwlGVA/Wfh0wHL2KAABxSSW3h9Mln+evpI/i2oXOAy8C3z8lRz6j9eb4HosKYiAZ48qxKZyBFjKsdAuD/AmbPiXHz3oEJKB1Br1XEHM7plRZ3;
From: Przemo Firszt <przemo@firszt.eu>
To: jkosina@suse.cz, pinglinux@gmail.com, peter.hutterer@who-t.net
Cc: linuxwacom-devel@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH] HID: wacom: Force new name for Wacom Intuos4 WL PTK-540WL
Date: Fri, 17 Feb 2012 17:47:10 +0000
Message-Id: <1329500830-16767-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.6.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name reported by Inutos4 WL connected by bluetooth is "PTK-540WL" and
to make it consistent with other Wacom devices it has to be converted to
"Wacom Intuos4 WL". It also makes userland applications aware that it's
a Wacom device.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/hid/hid-wacom.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index acab74c..0621047 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -518,6 +518,7 @@ static int wacom_probe(struct hid_device *hdev,
 		wacom_poke(hdev, 1);
 		break;
 	case USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH:
+		sprintf(hdev->name, "%s", "Wacom Intuos4 WL");
 		wdata->features = 0;
 		wacom_set_features(hdev);
 		break;
-- 
1.7.6.4

