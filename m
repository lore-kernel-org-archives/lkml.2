Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1AYRIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:08:42 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49497 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab1AYRIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:08:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=H8Azmf06tPL67S4eRTZES7zbqutMLmK+oGX2RVr+/W15xyB+2t3Yr+sYolEQFWr2w0
         vkfbODMohSM+5C+VGlX8+fXA6AQ0A/HtkFG296X6+UCdwrzpXfCranWMHdTGOpNyWjc/
         nE0KDF1Ob7+gFWeX5RxSoNxWikiz7u7NKwzAQ=
MIME-Version: 1.0
Date: Tue, 25 Jan 2011 22:38:38 +0530
Message-ID: <AANLkTimYvL7yn-X3ahUEt9EL4OVWQ=K-Spfc47qodh9J@mail.gmail.com>
Subject: [PATCH 2.6.37 2/4] edac: correct i82975x mci initialisation
From: Arvind R <arvino55@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 2.6.37 2/4] edac: correct i82975x mci initialisation

corrected mtype, and added dev_name,scrubmode initialisers
in i82975x struct mem_ctl initialisation

Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 i82975x_edac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
---
diff -up a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -511,18 +511,20 @@ static int i82975x_probe1(struct pci_dev

 	debugf3("%s(): init mci\n", __func__);
 	mci->dev = &pdev->dev;
-	mci->mtype_cap = MEM_FLAG_DDR;
+	mci->mtype_cap = MEM_FLAG_DDR2;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
 	mci->edac_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = I82975X_REVISION;
 	mci->ctl_name = i82975x_devs[dev_idx].ctl_name;
+	mci->dev_name = pci_name(pdev);
 	mci->edac_check = i82975x_check;
 	mci->ctl_page_to_phys = NULL;
 	debugf3("%s(): init pvt\n", __func__);
 	pvt = (struct i82975x_pvt *) mci->pvt_info;
 	pvt->mch_window = mch_window;
 	i82975x_init_csrows(mci, pdev, mch_window);
+	mci->scrub_mode = SCRUB_HW_SRC;
 	i82975x_get_error_info(mci, &discard);  /* clear counters */

 	/* finalize this instance of memory controller with edac core */
