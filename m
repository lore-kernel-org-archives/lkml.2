Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab2BXNsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:48:42 -0500
Received: from stats.peacock.arvixe.com ([174.122.104.67]:55146 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756508Ab2BXNsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:48:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer;
	b=DQdNASB0hrWVeFCeGOvFqn78eHsYLW75KC1ClJvlvRQi7QRHtWa59Y59tDw1Iv1gXCVFurKkyB3inkUXxhyyKNY0XO8/6WQ9EdJ/a9AhtdOU94akQ9H+HFEoYIWIii/j;
From: Przemo Firszt <przemo@firszt.eu>
To: jkosina@suse.cz, pinglinux@gmail.com, chris@cnpbagwell.com
Cc: linuxwacom-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 1/2] HID: wacom: set ABS_MISC bit for Intuos4 WL
Date: Fri, 24 Feb 2012 13:47:48 +0000
Message-Id: <1330091269-8765-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.6.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ABS_MISC has to be set for Intuos4 WL otherwise xorg driver won't use proper
protocol and the information about tool id and serial is lost.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
Reviewed-by: Chris Bagwell <chris@cnpbagwell.com>
---
 drivers/hid/hid-wacom.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 696b907..a793753 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -471,6 +471,7 @@ static int wacom_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		input_set_abs_params(input, ABS_DISTANCE, 0, 32, 0, 0);
 		break;
 	case USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH:
+		__set_bit(ABS_MISC, input->absbit);
 		input_set_abs_params(input, ABS_X, 0, 40640, 4, 0);
 		input_set_abs_params(input, ABS_Y, 0, 25400, 4, 0);
 		input_set_abs_params(input, ABS_PRESSURE, 0, 2047, 0, 0);
-- 
1.7.6.4

