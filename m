Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab0EXWiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:38:52 -0400
Received: from kroah.org ([198.145.64.141]:42417 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758517Ab0EXWi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:38:29 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 15:30:19 2010
Message-Id: <20100524223019.444600150@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 15:28:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [22/24] libata: ensure NCQ error result taskfile is fully initialized before returning it via qc->result_tf.
In-Reply-To: <20100524223544.GA13721@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Garzik <jeff@garzik.org>

commit a09bf4cd53b8ab000197ef81f15d50f29ecf973c upstream.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1497,6 +1497,7 @@ void ata_eh_analyze_ncq_error(struct ata
 	}
 
 	/* okay, this error is ours */
+	memset(&tf, 0, sizeof(tf));
 	rc = ata_eh_read_log_10h(dev, &tag, &tf);
 	if (rc) {
 		ata_link_printk(link, KERN_ERR, "failed to read log page 10h "


