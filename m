Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab2AJUKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 15:10:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797Ab2AJUK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 15:10:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 12:08:50 2012
Message-Id: <20120110200850.199977303@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 12:06:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [05/20] offb: Fix bug in calculating requested vram size
In-Reply-To: <20120110200902.GA5674@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit c055fe0797b7bd8f6f21a13598a55a16d5c13ae7 upstream.

We used to try to request 8 times more vram than needed, which would
fail if the card has a too small BAR (observed with qemu & kvm).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/offb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/offb.c
+++ b/drivers/video/offb.c
@@ -377,7 +377,7 @@ static void __init offb_init_fb(const ch
 				int pitch, unsigned long address,
 				int foreign_endian, struct device_node *dp)
 {
-	unsigned long res_size = pitch * height * (depth + 7) / 8;
+	unsigned long res_size = pitch * height;
 	struct offb_par *par = &default_par;
 	unsigned long res_start = address;
 	struct fb_fix_screeninfo *fix;


