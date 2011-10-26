Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1JZW1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 18:27:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:25284 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab1JZW1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 18:27:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208,223";a="68309621"
Subject: Re: 3.1-rc9 and 3.1 wifi problem , problem continues with 3.1
From: wwguy <wey-yi.w.guy@intel.com>
To: werner <w.landgraf@ru.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "dave.taht@gmail.com" <dave.taht@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "arend@broadcom.com" <arend@broadcom.com>,
        "toralf.foerster@gmx.de" <toralf.foerster@gmx.de>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "larry.finger@gmail.com" <larry.finger@gmail.com>
In-Reply-To: <web-633781994@zbackend1.aha.ru>
References: <web-633781994@zbackend1.aha.ru>
Content-Type: multipart/mixed; boundary="=-ifsGQZZ21yoKllp1JE/N"
Date: Wed, 26 Oct 2011 15:21:22 -0700
Message-ID: <1319667682.14693.29.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ifsGQZZ21yoKllp1JE/N
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2011-10-26 at 14:47 -0700, werner wrote:
> As reported, with 3.1-rc9 the wifi of a friend's laptop 
> didnt work at all.  With 3.0.4 it's working normally.
> 
> The problem continues with 3.1
> 
> Now I take some files for identify the problem.  Below see 
> lsmod and dmesg , and enclosed is hwinfo and syslog of 
> that laptop as it was running with 3.1 just as wifi didn't 
> work.      For comparison, on syslog you can see the 
> previous boots (I separated them by blank lines), all with 
> 3.0.4 , when wifi was working.
> 
> I hope that's now enough information to fix that problem.
> 
> 
> Werner Landgraf


could you try this test patch

Thanks
Wey

--=-ifsGQZZ21yoKllp1JE/N
Content-Disposition: attachment; filename="0001-iwlwifi-allow-pci_enable_msi-fail.patch"
Content-Type: text/x-patch; name="0001-iwlwifi-allow-pci_enable_msi-fail.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 64a1b22cc9d179d69c66b23619691ba2a13ee646 Mon Sep 17 00:00:00 2001
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Wed, 26 Oct 2011 15:15:38 -0700
Subject: [PATCH 1/1] iwlwifi: allow pci_enable_msi fail

Continue the init process even fail to enable msi

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 35d4551..911186f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -429,10 +429,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
 	err = pci_enable_msi(pdev);
-	if (err) {
-		dev_printk(KERN_ERR, &pdev->dev, "pci_enable_msi failed");
-		goto out_iounmap;
-	}
+	if (err)
+		dev_printk(KERN_ERR, &pdev->dev,
+			"pci_enable_msi failed(0X%x)", err);
 
 	/* TODO: Move this away, not needed if not MSI */
 	/* enable rfkill interrupt: hw bug w/a */
-- 
1.7.0.4


--=-ifsGQZZ21yoKllp1JE/N--

