Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab0J0UW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:22:27 -0400
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:47523 "HELO
	web31807.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756549Ab0J0UWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:22:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=LVal8wlbFk15zBiTp1j9yKCeqIiOhx6t01qV2B2YRpiZcL0DPoxEXuW637DT/l61x22MjBQuPBDfDOYRJgBS4UzzJ2DPe6oLujNoNk3RYPSwSV+V54L6s2SJQ+RWjzl2SGXFGQeZElyR0OuAok2KO/j0aWaIK/wX0cQ9cG98kH4=;
Message-ID: <628096.54960.qm@web31807.mail.mud.yahoo.com>
X-YMail-OSG: 9Fym5acVM1mID3EHnb4dARBXmQuHVWFH3.z9Yu3BlmPvMrL
 2bqfhxZbh885vOKnTX.x4ipjlOI6zH36I_cBPJKIN.wklHeFB9V_1yBIXGM1
 _zzJh..EhPezLJafKgusx_Xx8I61MiuYsw0p31mYR7lihTRNKCjB0EQ_SzhZ
 elBu4CHf7qBXs4JWjneJhqJQvnR3CIWmxoV56XYRwLE6M.RVgKOvoMBZBKxY
 iWK57tv4MmRZyMWZozeLBFK4NdxxVgBK_GUiuxEOeV0.kv3kRYLQoCDk3hNG
 UYEsKTSAOsy.xYYF99yyNjAbQT7rpwPAHIEPn6Qu2YgRi63xVqOaShAsJHVC
 pmAw1aiAYKKjDmqN_8Rw03pzCW22UzUqzTQ--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Wed, 27 Oct 2010 13:22:22 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: [PATCH] [USB] UAS: Use kzalloc instead of kmalloc
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        willy@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Be conservative in what you send, liberal in what
you accept." -- In the spirit of this adage, don't
send Command IUs with randomly filled in data in
the reserved fields. (Yes, this shows up on the
wire.)

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/usb/storage/uas.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 2054b1e..17e1820 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -294,7 +294,7 @@ static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 	if (!urb)
 		goto out;
 
-	iu = kmalloc(sizeof(*iu), gfp);
+	iu = kzalloc(sizeof(*iu), gfp);
 	if (!iu)
 		goto free;
 
@@ -325,7 +325,7 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 	if (len < 0)
 		len = 0;
 	len = ALIGN(len, 4);
-	iu = kmalloc(sizeof(*iu) + len, gfp);
+	iu = kzalloc(sizeof(*iu) + len, gfp);
 	if (!iu)
 		goto free;
 
@@ -660,7 +660,7 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 			return -ENODEV;
 	}
 
-	devinfo = kmalloc(sizeof(struct uas_dev_info), GFP_KERNEL);
+	devinfo = kzalloc(sizeof(struct uas_dev_info), GFP_KERNEL);
 	if (!devinfo)
 		return -ENOMEM;
 
-- 
1.7.0.1

