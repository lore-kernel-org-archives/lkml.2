Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab2DTWwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:52:14 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:38263 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab2DTWwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:52:10 -0400
From: "Shergill, Gurinder" <gurinder.shergill@hp.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        "james.bottomley@hansenpartnership.com" 
	<james.bottomley@hansenpartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gates, Matt" <matthew.gates@hp.com>,
        "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>,
        "thenzl@redhat.com" <thenzl@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mikem@beardog.cce.hp.com" <mikem@beardog.cce.hp.com>
Date: Fri, 20 Apr 2012 23:49:25 +0100
Subject: RE: [PATCH 04/17] hpsa: suppress excessively chatty error messages
Thread-Topic: [PATCH 04/17] hpsa: suppress excessively chatty error messages
Thread-Index: Ac0fCNsYWHpjnJRkQnWO9j8alTwAgwAPpONQ
Message-ID: <C508F8684F59FF47960D08B35B998FFE6563003D67@GVW1341EXA.americas.hpqcorp.net>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
 <20120420150634.10596.30524.stgit@beardog.cce.hp.com>
In-Reply-To: <20120420150634.10596.30524.stgit@beardog.cce.hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3KMqOCe007337

| -----Original Message-----
| From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
| owner@vger.kernel.org] On Behalf Of Stephen M. Cameron
| Sent: Friday, April 20, 2012 8:07 AM
| To: james.bottomley@hansenpartnership.com
| Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Gates, Matt;
| stephenmcameron@gmail.com; thenzl@redhat.com; akpm@linux-foundation.org;
| mikem@beardog.cce.hp.com
| Subject: [PATCH 04/17] hpsa: suppress excessively chatty error messages
| 
| From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
| 
| Default behavior for any CHECK CONDITION excepting a few special cases is
| to print out certain parts of the sense buffer and the CDB.  Default
| behavior should be to print nothing and let the upper layers or
| applications decide what to do about these.  The same information is
| already available by setting the appropriate bits of the
| scsi_logging_level kernel parameter or via
| /proc/sys/dev/scsi/logging_level.

Makes sense.

| 
| Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
| ---
|  drivers/scsi/hpsa.c |    2 +-
|  1 files changed, 1 insertions(+), 1 deletions(-)
| 
| diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c index
| 906672b..fcb9fb2 100644
| --- a/drivers/scsi/hpsa.c
| +++ b/drivers/scsi/hpsa.c
| @@ -1193,7 +1193,7 @@ static void complete_scsi_command(struct CommandList
| *cp)
|  				break;
|  			}
|  			/* Must be some other type of check condition */
| -			dev_warn(&h->pdev->dev, "cp %p has check condition: "
| +			dev_dbg(&h->pdev->dev, "cp %p has check condition: "
|  					"unknown type: "
|  					"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
|  					"Returning result: 0x%x, "
| 

Few lines further down in the same function, there is another dev_warn() for SCSI errors.

       /* Problem was not a check condition
         * Pass it up to the upper layers...
         */
        if (ei->ScsiStatus) {
            dev_warn(&h->pdev->dev, "cp %p has status 0x%x "
                "Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "


I am wondering whether it make sense to make the same change here as well as. This will suppress logging for other SCSI status, for example BUSY, TASK SET FULL, etc.

Sunny 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
