Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab0LHXvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:51:42 -0500
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:30668 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755198Ab0LHXvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:51:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=ZCx+Mcd6VVJk7rY/nNJ+pTBCgBzUbAVAizwh3MSNfnoAHGcmVDT/M2Pn3Bll0pJhQHBW2n7IrnURFqfYlop4zDcBaW6Tr8UeYdY9wLgfifTEW6V0YOkklXJ8sGZFQq1P9iIMTeWCSXdz9Eu1avD4H017KM4drxaXYm5NU9b9ULo=;
Message-ID: <21690.835.qm@web31801.mail.mud.yahoo.com>
X-YMail-OSG: y6CB2VkVM1kjtmp5PYLZZec97dd8F8x0JrXIccl1RoZ3Lmq
 MHe.SkIsWVEt9NJqrz.JpVhyDgjMzQhtt7KcAMQj3G_yOBNAWlBC_Wxvci2K
 eE3QIzM7u1ft_OSM0hWbe6tuS2IKyHlHJTADg1sWsyFh2GyCe9BRKChhOGi0
 iIQoJkbBYNXtsVf5hk_Z8_DQV5Ezn4O6YIlnm_pJyVq1.bUz5T1acPH1UUU5
 a09_vfJ5dnedjGbQtXm85bO7Ak3xr.vGY_FD_nI.q.f9PqpD3NWaf4AJAB80
 XTu4oGPtAJQHQKxOV62oFJnK2XpCCFiGi2eWWt6HvFOxI9uai7UcZbyVeryu
 QupPYt2fXSgZKpcmLsadjdwljuOdVJTXxaEOwAq3OPxoG
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Wed, 8 Dec 2010 15:51:38 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: [PATCH 1/4] [USB] UASP: Set iface data before scanning host
To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/usb/storage/uasp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/uasp.c b/drivers/usb/storage/uasp.c
index 1d2b2e3..3b10efd 100644
--- a/drivers/usb/storage/uasp.c
+++ b/drivers/usb/storage/uasp.c
@@ -1059,8 +1059,8 @@ static int uasp_probe(struct usb_interface *iface,
 		goto Free;
 
 	shost->hostdata[0] = (unsigned long)tpinfo;
-	scsi_scan_host(shost);
 	usb_set_intfdata(iface, shost);
+	scsi_scan_host(shost);
 
 	return res;
  Free:
-- 
1.7.0.1


