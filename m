Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab0KSWEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:04:06 -0500
Received: from kroah.org ([198.145.64.141]:52799 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757870Ab0KSWEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:02 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:22 2010
Message-Id: <20101119220122.438566039@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:00:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [03/66] Staging: phison: fix problem caused by libata change
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit cf10700bf8047f0668dd874b607f89516612e6c7 upstream.

The libata core changed this function so it needed to call a different
one.

See https://bugzilla.kernel.org/show_bug.cgi?id=19872 for details.

Reported-by: Heinz Wiesinger <HMWiesinger@gmx.at>
Tested-by: Heinz Wiesinger <HMWiesinger@gmx.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/phison/phison.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/phison/phison.c
+++ b/drivers/staging/phison/phison.c
@@ -62,7 +62,7 @@ static int phison_init_one(struct pci_de
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	ret = ata_pci_sff_init_one(pdev, ppi, &phison_sht, NULL, 0);
+	ret = ata_pci_bmdma_init_one(pdev, ppi, &phison_sht, NULL, 0);
 
 	dev_dbg(&pdev->dev, "phison_init_one(), ret = %x\n", ret);
 


