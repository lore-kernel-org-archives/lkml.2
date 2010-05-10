Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab0EJXKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:10:40 -0400
Received: from kroah.org ([198.145.64.141]:45440 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932961Ab0EJW6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:41 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:42 2010
Message-Id: <20100510223542.848982840@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [94/98] [SCSI] scsi_debug: virtual_gb ignores sector_size
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Douglas Gilbert <dgilbert@interlog.com>

commit 5447ed6c968e7270b656afa273c2b79d15d82edd upstream.

In the scsi_debug driver, the virtual_gb option ignores the
sector_size, implicitly assuming that is 512 bytes.  So if
'virtual_gb=1 sector_size=4096' the result is an 8 GB (virtual) disk.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_debug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -914,7 +914,8 @@ static int resp_start_stop(struct scsi_c
 static sector_t get_sdebug_capacity(void)
 {
 	if (scsi_debug_virtual_gb > 0)
-		return 2048 * 1024 * (sector_t)scsi_debug_virtual_gb;
+		return (sector_t)scsi_debug_virtual_gb *
+			(1073741824 / scsi_debug_sector_size);
 	else
 		return sdebug_store_sectors;
 }


