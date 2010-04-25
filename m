Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab0DYNn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:43:58 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58800 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab0DYNn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:43:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=pZM5DXLVELSab5a+31tleqep0sOGPTv/7lU3Ucvw3HnSHxYkzNsf+Kar7RP0Gnm+kQ
         44pN6+dKYFHSZ/+DsNjgqCNjkYJckW1v999ItDhHTEYdcWonOLA47LmIsJCm3VtgbB0Z
         oEMbAo6SCPAZhbvvJEZ68e++766+TARDVY8+s=
Date: Sun, 25 Apr 2010 22:23:21 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: yuasa@linux-mips.org, Naren Sankar <nsankar@broadcom.com>,
       Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
       Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] staging: crystalhd: mark all local functions static
Message-Id: <20100425222321.3f0181b9.yuasa@linux-mips.org>
In-Reply-To: <20100425221851.223dc284.yuasa@linux-mips.org>
References: <20100425221851.223dc284.yuasa@linux-mips.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
---
 drivers/staging/crystalhd/crystalhd_lnx.c |   23 ++++++++++++-----------
 drivers/staging/crystalhd/crystalhd_lnx.h |    4 ----
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 6ef54e3..a68b5ff 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -23,6 +23,11 @@ static struct class *crystalhd_class;
 
 static struct crystalhd_adp *g_adp_info;
 
+static struct crystalhd_adp *chd_get_adp(void)
+{
+	return g_adp_info;
+}
+
 static irqreturn_t chd_dec_isr(int irq, void *arg)
 {
 	struct crystalhd_adp *adp = (struct crystalhd_adp *) arg;
@@ -72,7 +77,8 @@ static int chd_dec_disable_int(struct crystalhd_adp *adp)
 	return 0;
 }
 
-crystalhd_ioctl_data *chd_dec_alloc_iodata(struct crystalhd_adp *adp, bool isr)
+static crystalhd_ioctl_data *chd_dec_alloc_iodata(struct crystalhd_adp *adp,
+						  bool isr)
 {
 	unsigned long flags = 0;
 	crystalhd_ioctl_data *temp;
@@ -92,8 +98,8 @@ crystalhd_ioctl_data *chd_dec_alloc_iodata(struct crystalhd_adp *adp, bool isr)
 	return temp;
 }
 
-void chd_dec_free_iodata(struct crystalhd_adp *adp, crystalhd_ioctl_data *iodata,
-			 bool isr)
+static void chd_dec_free_iodata(struct crystalhd_adp *adp,
+				crystalhd_ioctl_data *iodata, bool isr)
 {
 	unsigned long flags = 0;
 
@@ -613,7 +619,7 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 }
 
 #ifdef CONFIG_PM
-int chd_dec_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int chd_dec_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct crystalhd_adp *adp;
 	crystalhd_ioctl_data *temp;
@@ -647,7 +653,7 @@ int chd_dec_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-int chd_dec_pci_resume(struct pci_dev *pdev)
+static int chd_dec_pci_resume(struct pci_dev *pdev)
 {
 	struct crystalhd_adp *adp;
 	BC_STATUS sts = BC_STS_SUCCESS;
@@ -705,7 +711,7 @@ static struct pci_driver bc_chd_70012_driver = {
 #endif
 };
 
-void chd_set_log_level(struct crystalhd_adp *adp, char *arg)
+static void chd_set_log_level(struct crystalhd_adp *adp, char *arg)
 {
 	if ((!arg) || (strlen(arg) < 3))
 		g_linklog_level = BCMLOG_ERROR | BCMLOG_DATA;
@@ -725,11 +731,6 @@ void chd_set_log_level(struct crystalhd_adp *adp, char *arg)
 		g_linklog_level = 0;
 }
 
-struct crystalhd_adp *chd_get_adp(void)
-{
-	return g_adp_info;
-}
-
 static int __init chd_dec_module_init(void)
 {
 	int rc;
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.h b/drivers/staging/crystalhd/crystalhd_lnx.h
index e4cb6c7..f7fb15a 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.h
+++ b/drivers/staging/crystalhd/crystalhd_lnx.h
@@ -88,8 +88,4 @@ struct crystalhd_adp {
 	struct pci_pool		*fill_byte_pool;
 };
 
-
-struct crystalhd_adp *chd_get_adp(void);
-
 #endif
-
-- 
1.7.1

