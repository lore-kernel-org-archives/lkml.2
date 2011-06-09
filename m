Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab1FIMTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 08:19:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41436 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab1FIMTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:19:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=sQ+b5lx6MvQ9Ln6pWd0mORG4tguilELUPYVZWCZTxPvKcLstwmAolo0pwIueFLVixf
         w6q0+9UXfMhp3Qs8ZrCodpbineeyp0J0dDtn1x5NKtXyA/THdmLyJiOzK0idaoy75Y5G
         NDOK3DwUnWY/5Meo6b6KwgC4TniZ2eFL4wsvs=
Date: Thu, 9 Jun 2011 18:03:41 +0530
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: dyna_pci10xx: add mutex_destroy to detach
Message-ID: <20110609123341.GA18439@mail.fossee.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mutex_destroy() call to driver detach callback

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index d8821b9..b561a43 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -410,8 +410,10 @@ found:
 
 static int dyna_pci10xx_detach(struct comedi_device *dev)
 {
-	if (devpriv && devpriv->pci_dev)
+	if (devpriv && devpriv->pci_dev) {
 		comedi_pci_disable(devpriv->pci_dev);
+		mutex_destroy(&devpriv->mutex);
+	}
 
 	return 0;
 }
-- 
1.7.1

