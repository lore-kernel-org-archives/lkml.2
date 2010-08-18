Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0HROOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:14:42 -0400
Received: from n11.bullet.mail.ac4.yahoo.com ([74.6.228.83]:25104 "HELO
	n11.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753129Ab0HROOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:14:40 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 549226.35773.bm@omp111.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=r7AjQbVWyNVsbOVsOgX+wa4GA+S2K0FM4eQEo7ahhD53a5L9yKkGbVEVXG7ubFgkXrW2YBtoCRcCMqJ216lFOym2eqCByhLgZjbCftMR0FwmHF3yKzSaHgkzrdST9npiPxhDOso5vjsj4c4Cdp8l6aENdIn5T6wnSFATLmcb+x0=;
Message-ID: <281434.37339.qm@web65616.mail.ac4.yahoo.com>
X-YMail-OSG: VGFGVDkVM1kXu90YG4Qurt8UwIpYcdFdWDDIRudmz33siDd
 J_OlCFUP.pUkWuQ__M7qrsX1sD4ZbP4a.n.12GOTl6T9sfQwB8jDKrnHKM.1
 PVjeLPrQkZU7zRIjFVajvs1DuGG6_a5AtCWdcM7HqZV1nI9uqBssYMDCIZF2
 6elctGCsamnw3ghfE0mpZhFqIeBtUqMGwh8rD_HsMbPZHThv0tK7pbtr.lYe
 irGE3OkgTU9TZ7TTj5d6hw2.eKNHwDIlWqSdM0VUbJw53htuU2iovqMClp6s
 IA_tR9WU8WG3YGrZtfYWg5_flQfyQE1bL.l7F9n5CbRQyCw--
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Wed, 18 Aug 2010 07:14:37 -0700 (PDT)
From: Michael Wileczka <mikewileczka@yahoo.com>
Subject: [PATCH 001/001] USB: ftdi_sio: fix endianess of max packet size
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wileczka <mikewileczka@yahoo.com>

The USB max packet size (always little-endian) was not being byte swapped on big-endian systems.
Created with 2.6.32.16
Applicable since [USB: ftdi_sio: fix hi-speed device packet size calculation] approx 2.6.31

Signed-off-by: Michael Wileczka <mikewileczka@yahoo.com>
---
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1397,7 +1397,7 @@ static void ftdi_set_max_packet_size(str
 	}
 
 	/* set max packet size based on descriptor */
-	priv->max_packet_size = ep_desc->wMaxPacketSize;
+	priv->max_packet_size = le16_to_cpu(ep_desc->wMaxPacketSize);
 
 	dev_info(&udev->dev, "Setting MaxPacketSize %d\n", priv->max_packet_size);
 }



