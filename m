Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab0JMD0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 23:26:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53762 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab0JMD0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 23:26:05 -0400
Date: Wed, 13 Oct 2010 14:25:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: linux-next: build failure after merge of the usb tree with the scsi
 tree
Message-Id: <20101013142558.c46a6311.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

After merging the usb tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/scsi/sd.c: In function 'read_capacity_10':
drivers/scsi/sd.c:1637: error: 'struct scsi_disk' has no member named 'hw_sector_size'

Caused by commit a488ec87ee2e79911d10425cb0c0264290905b38 ("scsi/sd: add
a no_read_capacity_16 scsi_device flag") interacting with commit
526f7c7950bbf1271e59177d70d74438c2ef96de ("[SCSI] sd: Fix overflow with
big physical blocks") from the scsi tree.

I have applied the following patch for today and will carry it as a merge
fix as necessary.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 13 Oct 2010 14:15:15 +1100
Subject: [PATCH] scsi/sd: update for hw_sector_size rename

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/sd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8ca43e5..57d1e3e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1634,7 +1634,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		   0xffffffff when the want to report a size of 0 (with
 		   which they really mean no media is present) */
 		sdkp->capacity = 0;
-		sdkp->hw_sector_size = sector_size;
+		sdkp->physical_block_size = sector_size;
 		return sector_size;
 	}
 
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
