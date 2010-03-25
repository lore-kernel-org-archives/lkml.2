Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab0CYNGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:06:06 -0400
Received: from exchtp08.via.com.tw ([61.66.243.7]:62097 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab0CYNGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:06:04 -0400
X-Greylist: delayed 855 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Mar 2010 09:06:04 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [Patch 1/1 v2] pata_via: HDD of VT6410/6415/6330 cannot be detected issue
Date: Thu, 25 Mar 2010 20:51:47 +0800
Message-ID: <9E058EE846170743AF7338FE064CB5AB38B477@exchtp04.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch 1/1 v2] pata_via: HDD of VT6410/6415/6330 cannot be detected issue
thread-index: AcrMGe3ueTN7SzNbRsCdvGpbqQpJzQ==
From: <JosephChan@via.com.tw>
To: <linux-ide@vger.kernel.org>, <stable@kernel.org>,
       <linux-kernel@vger.kernel.org>
Cc: <sshtylyov@mvista.com>, <jeff@garzik.org>, <tj@kernel.org>
X-OriginalArrivalTime: 25 Mar 2010 12:51:48.0217 (UTC) FILETIME=[EE906690:01CACC19]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2PD6FmE005399

When using VT6410/6415/6330 chips on some VIA's platforms, the HDD connects to VT6410/6415/6330 cannot be detected.
It is because the driver detects wrong via_isa_bridge ID, and then cause the this issue happen.
This patch will fix this problem.


Signed-off-by: Joseph Chan<josephchan@via.com.tw>

--- a/drivers/ata/pata_via.c	2010-03-16 06:00:01.000000000 -0400
+++ b/drivers/ata/pata_via.c	2010-03-25 08:47:15.000000000 -0400
@@ -576,6 +576,10 @@
 			u8 rev = isa->revision;
 			pci_dev_put(isa);
 
+			if ((id->device == 0x0415 || id->device == 0x3164) &&
+			      (config->id != id->device))
+				continue;
+
 			if (rev >= config->rev_min && rev <= config->rev_max)
 				break;
 		}
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
