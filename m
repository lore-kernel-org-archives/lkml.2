Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab1HVKtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:49:36 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:33168 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab1HVKt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:49:29 -0400
Message-ID: <4E523430.1070003@linux.vnet.ibm.com>
Date: Mon, 22 Aug 2011 06:49:20 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        James Morris <jmorris@namei.org>
Subject: tpm: suppress durations sysfs output if not set
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppress the output of durations if they were not read during driver 
initialization.
This is similar to other sysfs entries that return nothing if for some 
reason sending the commands to the TPM fails.

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

+    if (chip->vendor.duration[TPM_LONG] == 0)
+        return 0;
+
      return sprintf(buf, "%d %d %d [%s]\n",
                 jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
                 jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
