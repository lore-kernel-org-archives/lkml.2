Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab1HWMxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 08:53:47 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39359 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab1HWMxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 08:53:43 -0400
Subject: [PATCH] [REPOST] tpm: suppress durations sysfs output if not read
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>, m.selhorst@sirrix.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 08:52:10 -0400
Message-ID: <1314103930.17826.2.camel@d941e-10>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppress the output in the 'durations' sysfs entry if they were not read
during driver initialization. This is similar to other sysfs entries
that return nothing if for some reason sending the commands to the TPM
fails.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.c
+++ linux-2.6/drivers/char/tpm/tpm.c
@@ -963,6 +963,9 @@ ssize_t tpm_show_durations(struct device
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
+	if (chip->vendor.duration[TPM_LONG] == 0)
+		return 0;
+
 	return sprintf(buf, "%d %d %d [%s]\n",
 		       jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
 		       jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),

