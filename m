Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab2EGPXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:23:14 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50597 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab2EGPW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:22:59 -0400
Message-ID: <1336404172.12030.7.camel@router7789>
Subject: [PATCH] re: drivers: Probable misuses of || -  it913x.c
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Mon, 07 May 2012 16:22:52 +0100
In-Reply-To: <4FA7A7D8.7000806@redhat.com>
References: <1333580415.23520.29.camel@joe2Laptop>
	 <4FA7A7D8.7000806@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 07:45 -0300, Mauro Carvalho Chehab wrote:
> Malcolm,
> 
> Em 04-04-2012 20:00, Joe Perches escreveu:
> > Likely these should be && not ||
> > 
> > drivers/scsi/FlashPoint.c:				if(bit_cnt != 0 || bit_cnt != 8)
> 
> > drivers/media/dvb/dvb-usb/it913x.c:		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)
> > drivers/media/dvb/dvb-usb/it913x.c:		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)
> 
> Could you please take a look on the above?

Hmm... yes, thanks, also a bug.

Just check for -EBUSY && -ETIMEDOUT

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 482d249..6244fe9 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -81,7 +81,7 @@ static int it913x_bulk_write(struct usb_device *dev,
 	for (i = 0; i < IT913X_RETRY; i++) {
 		ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, pipe),
 				snd, len , &actual_l, IT913X_SND_TIMEOUT);
-		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)
+		if (ret != -EBUSY && ret != -ETIMEDOUT)
 			break;
 	}
 
@@ -99,7 +99,7 @@ static int it913x_bulk_read(struct usb_device *dev,
 	for (i = 0; i < IT913X_RETRY; i++) {
 		ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, pipe),
 				 rev, len , &actual_l, IT913X_RCV_TIMEOUT);
-		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)
+		if (ret != -EBUSY && ret != -ETIMEDOUT)
 			break;
 	}
 
-- 
1.7.9.5


