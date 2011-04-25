Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab1DYUrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:47:07 -0400
Received: from 1wt.eu ([62.212.114.60]:34252 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139Ab1DYUYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:40 -0400
Message-Id: <20110425200238.121685446@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: James Bottomley <James.Bottomley@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 118/173] [SCSI] ses: show devices for enclosures with no page 7
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Hughes <john@Calva.COM>

commit 877a55979c189c590e819a61cbbe2b7947875f17 upstream.

enclosure page 7 gives us the "pretty" names of the enclosure slots.
Without a page 7, we can still use the enclosure code as long as we
make up numeric names for the slots. Unfortunately, the current code
fails to add any devices because the check for page 10 is in the wrong
place if we have no page 7.  Fix it so that devices show up even if
the enclosure has no page 7.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/ses.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -389,9 +389,9 @@ static void ses_enclosure_data_process(s
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


