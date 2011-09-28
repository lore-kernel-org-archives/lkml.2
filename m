Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab1I1GlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:41:02 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:50949 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1I1GlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:41:00 -0400
Date: Wed, 28 Sep 2011 16:40:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Franky Lin <frankyl@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the moduleh tree with the staging tree
Message-Id: <20110928164057.02bd5c0e3f67e9748907986b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/staging/brcm80211/brcmfmac/bcmsdh.c between commit 47b4c640b849
("staging: brcm80211: remove global var gInstance from brcmfmac") from
the staging tree and commit 15f310ea9641 ("staging: Add export.h for
THIS_MODULE/EXPORT_SYMBOL to drivers/staging users") from the moduleh
tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 8448b8b,51f9335..0000000
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@@ -21,9 -22,7 +22,10 @@@
  #include <linux/pci_ids.h>
  #include <linux/sched.h>
  #include <linux/completion.h>
 +#include <linux/mmc/sdio.h>
 +#include <linux/mmc/sdio_func.h>
 +#include <linux/mmc/card.h>
+ #include <linux/export.h>
  
  #include <defs.h>
  #include <brcm_hw_ids.h>
