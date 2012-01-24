Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab2AXDGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:06:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab2AXCot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:44:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:28 2012
Message-Id: <20120124023928.703471360@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Richard Weinberger <rw@linutronix.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [054/129] UBI: make vid_hdr non-static
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 931
Lines: 30

From: Richard Weinberger <rw@linutronix.de>

commit 6bdccffe8c4268d02f71873102131fb6ed37ed9a upstream.

Remove 'static' modifier from the 'vid_hdr' local variable. I do not know
how it slipped in, but this is a bug and will break UBI if someone attaches
2 UBI volumes at the same time.

Artem: amended teh commit message, added -stable.

Signed-off-by: Richard Weinberger <rw@linutronix.de>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/ubi/vtbl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -306,7 +306,7 @@ static int create_vtbl(struct ubi_device
 		       int copy, void *vtbl)
 {
 	int err, tries = 0;
-	static struct ubi_vid_hdr *vid_hdr;
+	struct ubi_vid_hdr *vid_hdr;
 	struct ubi_scan_leb *new_seb;
 
 	ubi_msg("create volume table (copy #%d)", copy + 1);


