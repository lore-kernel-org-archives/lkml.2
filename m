Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab2CNTzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 15:55:47 -0400
Received: from stats.peacock.arvixe.com ([174.122.104.67]:57096 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932475Ab2CNTzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 15:55:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer;
	b=c2YrKdvyVagu68Mt3eWiXEz2deaCTSqM0+Est3aLvNuQaky3Er1STvMbQDweLeciL8+mi/HKCVIV3SUUQIP03UsyQLVEIKfMsWggwNpY5NtSfP5e+coH9d3ZYv2QNAHq;
From: Przemo Firszt <przemo@firszt.eu>
To: jkosina@suse.cz, pinglinux@gmail.com, chris@cnpbagwell.com,
        killertofu@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net,
        Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 1/2] HID: wacom: Replace __set_bit with input_set_capability
Date: Wed, 14 Mar 2012 19:55:03 +0000
Message-Id: <1331754904-8927-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.6.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a trivial patch. It's doesn't change the functionality as the helper
input_set_capability does the same thing.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/hid/hid-wacom.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 5c25036..d04e2aa 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -492,9 +492,7 @@ static int wacom_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 	__set_bit(BTN_MIDDLE, input->keybit);
 
 	/* Pad */
-	input->evbit[0] |= BIT(EV_MSC);
-
-	__set_bit(MSC_SERIAL, input->mscbit);
+	input_set_capability(input, EV_MSC, MSC_SERIAL);
 
 	__set_bit(BTN_0, input->keybit);
 	__set_bit(BTN_1, input->keybit);
-- 
1.7.6.4

