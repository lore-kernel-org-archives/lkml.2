Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab1DMQMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:12:15 -0400
Received: from kroah.org ([198.145.64.141]:54214 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594Ab1DMPzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:08 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:43 2011
Message-Id: <20110413155143.799888752@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:50:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <James.Bottomley@suse.de>
Subject: [08/74] [SCSI] ses: show devices for enclosures with no page 7
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


