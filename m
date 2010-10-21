Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab0JUWwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:52:17 -0400
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:34575 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752044Ab0JUWwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:52:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=5UpGcquzr5ypbLX+NUksASmy25X0RGejiNls2+Qk7QLBF2NhhsCbTANkWeRdGeU9TB+EYk+uWzRVpWvhaNAZDontzl4fTBW3VwRD94LET3GMbESihbMRyhf7/Wg1tmQESDzeXirhudsI6XaIX9l6ZOdCrmqBwVeClGhanQibPy8=;
Message-ID: <662065.4331.qm@web31812.mail.mud.yahoo.com>
X-YMail-OSG: o6CDFzQVM1ng29xJRouRxyoqev3OR28AHe.w0Gz57z2gS1d
 DM0zDlD6r2VnL9V95965dje7UyNQyCEoEN2FgcsThp6yHu6iIf6izzQfcAgj
 qNZT4FzciGa5YWxllIExHFlKnHgR.F2D90YRz16olTOFPh3KUzXgzbkvc142
 Y2jqoOrbBHJXjXQtJM1GV3DdGeRWsPYw0ITyXUx4DIGKZwNwiAeepdooDXHr
 DYZPbwaBIeueuRXL6N5u8EtYF5MC_F9cW7OuDBCKhdfP2rPxSA89EdvZBl2E
 5Kuvh2IxJVYorqN9GrXe4wSqDaKaF3NtBcUwc9D.oxq3vuz51_tsZIjHmu8D
 R13gcIVYgIyeGlXpifpQhKkHhXadukCNpcA--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Thu, 21 Oct 2010 15:52:12 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: [PATCH] [USB] Allow retrieval of the Caching mode page
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The statement of the comment removed by this
patch, "A number of devices have problems with
MODE SENSE for page x08, so we will skip it" is
certainly too general to apply for *all*
devices. This patch removes the unconditional
retrieval constraint of the Caching mode page.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/usb/storage/scsiglue.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index d8d98cf..c3cb60d 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -193,10 +193,6 @@ static int slave_configure(struct scsi_device *sdev)
 		if (us->fflags & US_FL_NO_WP_DETECT)
 			sdev->skip_ms_page_3f = 1;
 
-		/* A number of devices have problems with MODE SENSE for
-		 * page x08, so we will skip it. */
-		sdev->skip_ms_page_8 = 1;
-
 		/* Some disks return the total number of blocks in response
 		 * to READ CAPACITY rather than the highest block number.
 		 * If this device makes that mistake, tell the sd driver. */
-- 
1.7.0.1

