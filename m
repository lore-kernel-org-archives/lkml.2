Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0F1U3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:29:46 -0400
Received: from cheetah.host-care.com ([66.7.219.192]:54759 "EHLO
	cheetah.host-care.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab0F1U3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:29:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Assp-Whitelisted:X-Assp-Envelope-From:X-Assp-Intended-For:X-Source:X-Source-Args:X-Source-Dir;
	b=WSdXOMTnf4OS7mfTg/nqNFHd9aiVJN8f/OX5CTF+3WojxqNxLu02fuEkVJeGBKhQezmZYLCi5DkVVo9jVIyBipG7MzJaB5BP9dKHJy3Sfy6Bj1QZRbcSIh9R06DpUayS;
From: Przemo Firszt <przemo@firszt.eu>
To: oliver@neukum.name, gregkh@suse.de, alan@linux.intel.com,
       francescolavra@interfree.it, julian.calaby@gmail.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH] Expose vendor-specific ACM channel on Nokia 5230
Date: Mon, 28 Jun 2010 21:29:34 +0100
Message-Id: <1277756974-3373-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.1
X-Assp-Whitelisted: Yes
X-Assp-Envelope-From: przemo@firszt.eu
X-Assp-Intended-For: oliver@neukum.name
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cheetah.host-care.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nokia S60 phones expose two ACM channels. The first is
a modem, the second is 'vendor-specific' but is treated
as a serial device at the S60 end, so we want to expose
it on Linux too.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/usb/class/cdc-acm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 61d7550..162c95a 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1596,6 +1596,7 @@ static const struct usb_device_id acm_ids[] = {
 	{ NOKIA_PCSUITE_ACM_INFO(0x00e9), }, /* Nokia 5320 XpressMusic */
 	{ NOKIA_PCSUITE_ACM_INFO(0x0108), }, /* Nokia 5320 XpressMusic 2G */
 	{ NOKIA_PCSUITE_ACM_INFO(0x01f5), }, /* Nokia N97, RM-505 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x02e3), }, /* Nokia 5230, RM-588 */
 
 	/* NOTE: non-Nokia COMM/ACM/0xff is likely MSFT RNDIS... NOT a modem! */
 
-- 
1.7.1

