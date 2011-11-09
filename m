Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915Ab1KJDVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:21:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933844Ab1KJDVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:21:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:04 2011
Message-Id: <20111109212704.428321328@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Stezenbach <js@sig21.net>
Subject: [041/262] usbmon vs. tcpdump: fix dropped packet count
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1101,7 +1101,7 @@ static long mon_bin_ioctl(struct file *f
 		nevents = mon_bin_queued(rp);
 
 		sp = (struct mon_bin_stats __user *)arg;
-		if (put_user(rp->cnt_lost, &sp->dropped))
+		if (put_user(ndropped, &sp->dropped))
 			return -EFAULT;
 		if (put_user(nevents, &sp->queued))
 			return -EFAULT;


