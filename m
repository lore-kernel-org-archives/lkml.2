Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab2CMBHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:07:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:46661 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847Ab2CMARo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, John Hughes <john@calva.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 012/196] ses: show devices for enclosures with no page 7
Date: Mon, 12 Mar 2012 20:12:20 -0400
Message-Id: <1331597724-31358-13-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Hughes <john@Calva.COM>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 877a55979c189c590e819a61cbbe2b7947875f17 upstream.

enclosure page 7 gives us the "pretty" names of the enclosure slots.
Without a page 7, we can still use the enclosure code as long as we
make up numeric names for the slots. Unfortunately, the current code
fails to add any devices because the check for page 10 is in the wrong
place if we have no page 7.  Fix it so that devices show up even if
the enclosure has no page 7.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/ses.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 7f5a6a8..3b00e90 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -390,9 +390,9 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 		len = (desc_ptr[2] << 8) + desc_ptr[3];
 		/* skip past overall descriptor */
 		desc_ptr += len + 4;
-		if (ses_dev->page10)
-			addl_desc_ptr = ses_dev->page10 + 8;
 	}
+	if (ses_dev->page10)
+		addl_desc_ptr = ses_dev->page10 + 8;
 	type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
 	components = 0;
 	for (i = 0; i < types; i++, type_ptr += 4) {
-- 
1.7.9.3

