Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab0C3XXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:23:24 -0400
Received: from kroah.org ([198.145.64.141]:46925 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716Ab0C3XWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:22:24 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:01 2010
Message-Id: <20100330224901.391243378@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:43:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joseph Chan <josephchan@via.com.tw>, Jeff Garzik <jgarzik@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [156/156] pata_via: fix VT6410/6415/6330 detection issue
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: JosephChan@via.com.tw <JosephChan@via.com.tw>

commit bc8a67386fd462914269fa93446e1891955a8bb3 upstream.

When using VT6410/6415/6330 chips on some VIA's platforms, the HDD
connection to VT6410/6415/6330 cannot be detected.

It is because the driver detects wrong via_isa_bridge ID, and then
causes this issue to happen.

Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_via.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -588,6 +588,10 @@ static int via_init_one(struct pci_dev *
 			u8 rev = isa->revision;
 			pci_dev_put(isa);
 
+			if ((id->device == 0x0415 || id->device == 0x3164) &&
+			    (config->id != id->device))
+				continue;
+
 			if (rev >= config->rev_min && rev <= config->rev_max)
 				break;
 		}


