Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab1ERV47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:56:59 -0400
Received: from nm10-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.140]:37409 "HELO
	nm10-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750998Ab1ERV46 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:56:58 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 May 2011 17:56:58 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 95928.50940.bm@omp1010.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=YwsvvwqyMrW3Eyi/bnXTbxR3zYAEttu9jqsBHLjDrXFRCB+H6y72vrk4brLY/zJfrfDJ6AipukAwE49OY4GCWR+gdJscx7iRdHC8nvLH5SqXtLhiR7klebiWLirysin5xeYzUCqvxXstimYLFIZivKLwmwsnRPUfcZisHVnVe78=;
Message-ID: <2062.44194.qm@web120510.mail.ne1.yahoo.com>
X-YMail-OSG: Ljv6_6IVM1n6FJ2OhOp2G9KsrntjPORcwTjvZXHX8AiL_s6
 _eOoQybQ.djECX0veUzfNZWkPk9RXI0ngvM.s8mfhKs8om8zqoVtlam8CNgz
 jPkjD17GgR1UkufQyL0ZHfnOf6tOkDVEY.Hzktk5SAUDKs6zlf_iK0V9PW7I
 5Ms629Y7edz30H.1NbgCD_jUkzbgkR0.jJHX4xrCy8Fox5DCuxo6OeB_Zysk
 ZEEbZLX7yroUlKLAu0BOEISptsPg3yChSvEr4GLhHHiOd4YsjtsfFv9_UtoN
 tTKD8v9Z4X.XutTxwjGxThNuf5oG6gh_PEXbzMITy8lcutPbBE1orf9OSB9M
 TA9VfggsdCvMMzmsmZ.RxN4WB75iZlTORSJL8MyKu2tHZ0yGTjGPx4hM-
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.111.303096
Date: Wed, 18 May 2011 14:51:14 -0700 (PDT)
From: Dennis Aberilla <denzzzhome@yahoo.com>
Subject: [PATCH] drivers/net: ks8842 Fix crash on received packet when in PIO mode.
To: info@mocean-labs.com
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a kernel crash during packet reception due to not enough allocated bytes for the skb. This applies to the driver when running in PIO mode in an ISA bus setup.

Signed-off-by: Dennis Aberilla <denzzzhome@yahoo.com>


---
diff --git a/drivers/net/ks8842.c b/drivers/net/ks8842.c
index f0d8346..9069aee 100644
--- a/drivers/net/ks8842.c
+++ b/drivers/net/ks8842.c
@@ -662,7 +662,7 @@ static void ks8842_rx_frame(struct net_device *netdev,

   /* check the status */
   if ((status & RXSR_VALID) && !(status & RXSR_ERROR)) {
-     struct sk_buff *skb = netdev_alloc_skb_ip_align(netdev, len);
+     struct sk_buff *skb = netdev_alloc_skb_ip_align(netdev, len + 2);

      if (skb) {



--

|Dennis
