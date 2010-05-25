Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515Ab0EYSRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:17:41 -0400
Received: from kroah.org ([198.145.64.141]:44407 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933454Ab0EYSRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:17:35 -0400
X-Mailbox-Line: From gregkh@clark.site Tue May 25 11:12:14 2010
Message-Id: <20100525181213.948838100@clark.site>
User-Agent: quilt/0.48-8.10
Date: Tue, 25 May 2010 11:09:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [19/25] libata: ensure NCQ error result taskfile is fully initialized before returning it via qc->result_tf.
In-Reply-To: <20100525181259.GA18630@kroah.com>
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


