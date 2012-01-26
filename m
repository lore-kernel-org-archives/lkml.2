Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab2AZR0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:26:14 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55296 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab2AZR0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:26:12 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 5/5] platform-x86: intel_mid_thermal: turn off thermistor
 voltage by default
To: mjg@redhat.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Jan 2012 17:39:46 +0000
Message-ID: <20120126173943.16719.16596.stgit@bob.linux.org.uk>
In-Reply-To: <20120126173729.16719.15431.stgit@bob.linux.org.uk>
References: <20120126173729.16719.15431.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

Instead of complaining that the voltage is on, we can just ask the MSIC to
turn the voltage off. This should save some power.

Voltage for thermistors is turned on when ADC conversion is initiated.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/platform/x86/intel_mid_thermal.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/drivers/platform/x86/intel_mid_thermal.c b/drivers/platform/x86/intel_mid_thermal.c
index aef4979..a4e56be 100644
--- a/drivers/platform/x86/intel_mid_thermal.c
+++ b/drivers/platform/x86/intel_mid_thermal.c
@@ -360,8 +360,10 @@ static int mid_initialize_adc(struct device *dev)
 	if (ret)
 		return ret;
 
-	if (data & MSIC_ADCTHERM_MASK)
-		dev_warn(dev, "ADCTHERM already set");
+	data &= ~MSIC_ADCTHERM_MASK;
+	ret = intel_msic_reg_write(INTEL_MSIC_ADC1CNTL3, data);
+	if (ret)
+		return ret;
 
 	/* Index of the first channel in which the stop bit is set */
 	channel_index = find_free_channel();

