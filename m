Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab0EJXVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:21:33 -0400
Received: from kroah.org ([198.145.64.141]:51579 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757405Ab0EJW50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:26 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:35 2010
Message-Id: <20100510223534.989331344@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [06/98] libata: ensure NCQ error result taskfile is fully initialized
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------
 before returning it via qc->result_tf.

From: Jeff Garzik <jeff@garzik.org>

commit a09bf4cd53b8ab000197ef81f15d50f29ecf973c upstream.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1619,6 +1619,7 @@ void ata_eh_analyze_ncq_error(struct ata
 	}
 
 	/* okay, this error is ours */
+	memset(&tf, 0, sizeof(tf));
 	rc = ata_eh_read_log_10h(dev, &tag, &tf);
 	if (rc) {
 		ata_link_printk(link, KERN_ERR, "failed to read log page 10h "


