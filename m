Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab0CVUqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:46:48 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:49553 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab0CVUqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=NEiylRD2yyRYGWu6eyfzEROGocm3o9TeqIIg/yPWL/3DbsMKrM5oAsXqtKB7kUOyNb
         BzegtFGY54sj7Q61LKFKKXfACSFKlsjrknhLnzgBnoFXWP+Mr4snX6yFv7DOC24V7Tqf
         PSb/GCZ2L0ngD3tQmBwlS/WRRMUxQIqtoJRdI=
Message-ID: <4BA7D7BB.1080506@gmail.com>
Date: Mon, 22 Mar 2010 21:48:59 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jing Huang <huangj@brocade.com>, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] bfa: wrong fcport H2I message tested in bfa_fcport_isr()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that the wrong fcport H2I message was tested

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Was this intended?

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index c589488..5e5e6fe 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -1281,7 +1281,7 @@ bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 		break;
 
 	case BFI_FCPORT_I2H_DISABLE_RSP:
-		if (fcport->msgtag == i2hmsg.penable_rsp->msgtag)
+		if (fcport->msgtag == i2hmsg.pdisable_rsp->msgtag)
 			bfa_sm_send_event(fcport, BFA_FCPORT_SM_FWRSP);
 		break;
 
