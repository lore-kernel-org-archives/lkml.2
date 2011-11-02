Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934582Ab1KCBlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:41:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934454Ab1KCBlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:41:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:45 2011
Message-Id: <20111102222745.222723756@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Stezenbach <js@sig21.net>
Subject: [060/101] usbmon vs. tcpdump: fix dropped packet count
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Stezenbach <js@sig21.net>

commit 236c448cb6e7f82096101e1ace4b77f8b38f82c8 upstream.

Report the number of dropped packets instead of zero
when using the binary usbmon interface with tcpdump.

# tcpdump -i usbmon1 -w dump
tcpdump: listening on usbmon1, link-type USB_LINUX_MMAPPED (USB with padded Linux header), capture size 65535 bytes
^C2155 packets captured
2155 packets received by filter
1019 packets dropped by kernel

Signed-off-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/mon/mon_bin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1074,7 +1074,7 @@ static int mon_bin_ioctl(struct inode *i
 		nevents = mon_bin_queued(rp);
 
 		sp = (struct mon_bin_stats __user *)arg;
-		if (put_user(rp->cnt_lost, &sp->dropped))
+		if (put_user(ndropped, &sp->dropped))
 			return -EFAULT;
 		if (put_user(nevents, &sp->queued))
 			return -EFAULT;


