Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab1KSAJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:09:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758380Ab1KSAJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:09:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:03:29 2011
Message-Id: <20111119000329.419617905@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 16:02:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, greg@kroah.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, roman-vl@meta.ua,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [17/26] b43: refuse to load unsupported firmware
In-Reply-To: <20111119000336.GA8452@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

[This patch is supposed to be applied in 3.1 (and maybe older) branches only.]

New kernels support newer firmware that users may try to incorrectly use
with older kernels. Display error and explain the problem in such a case

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/main.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2508,6 +2508,13 @@ static int b43_upload_microcode(struct b
 		b43_print_fw_helptext(dev->wl, 1);
 		err = -EOPNOTSUPP;
 		goto error;
+	} else if (fwrev >= 598) {
+		b43err(dev->wl, "YOUR FIRMWARE IS TOO NEW. Support for "
+		       "firmware 598 and up requires kernel 3.2 or newer. You "
+		       "have to install older firmware or upgrade kernel.\n");
+		b43_print_fw_helptext(dev->wl, 1);
+		err = -EOPNOTSUPP;
+		goto error;
 	}
 	dev->fw.rev = fwrev;
 	dev->fw.patch = fwpatch;


