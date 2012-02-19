Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2BSUVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 15:21:04 -0500
Received: from stats.peacock.arvixe.com ([174.122.104.67]:35258 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754794Ab2BSUVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 15:21:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer;
	b=XMGpcPYozljnm5YgZW7OZXne4KYehMOJw4hxiclX/1xKL1hsytBdbq6I3BnM9QHd1qY+srYy7BwLLRgsvpIjIDiRaorw0Ur9s2EAG0z+ORO2AJgTmE5aECXPMBTpNW8W;
From: Przemo Firszt <przemo@firszt.eu>
To: aris@redhat.com, jkosina@suse.cz
Cc: pinglinux@gmail.com, linuxwacom-devel@lists.sourceforge.net,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH] HID: wacom: fix proximity tool release
Date: Sun, 19 Feb 2012 20:20:29 +0000
Message-Id: <1329682829-24347-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.6.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't zero the current tool before reporting its release to the input
subsystem.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Tested-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/hid/hid-wacom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 0621047..696b907 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -322,10 +322,10 @@ static void wacom_i4_parse_pen_report(struct wacom_data *wdata,
 
 	switch (data[1]) {
 	case 0x80: /* Out of proximity report */
-		wdata->tool = 0;
 		input_report_key(input, BTN_TOUCH, 0);
 		input_report_abs(input, ABS_PRESSURE, 0);
 		input_report_key(input, wdata->tool, 0);
+		wdata->tool = 0;
 		input_sync(input);
 		break;
 	case 0xC2: /* Tool report */
-- 
1.7.6.4

