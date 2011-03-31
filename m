Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab1CaPHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:07:21 -0400
Received: from void.printf.net ([89.145.121.20]:60335 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab1CaPHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:07:18 -0400
From: Chris Ball <cjb@laptop.org>
To: Manoj <manoj.iyer@canonical.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: SDHCI: Ricoh [1180:e823] unable to mount MMC cards.
References: <4D93AD5C.1070308@canonical.com>
	<m34o6k43c4.fsf@pullcord.laptop.org> <4D93BDA9.1020107@canonical.com>
	<m3vcz02mi1.fsf@pullcord.laptop.org> <4D948BC4.6020904@canonical.com>
	<m3sju3z6yc.fsf@pullcord.laptop.org> <4D949298.4000701@canonical.com>
Date: Thu, 31 Mar 2011 11:13:10 -0400
In-Reply-To: <4D949298.4000701@canonical.com> (Manoj's message of "Thu, 31 Mar
	2011 09:41:28 -0500")
Message-ID: <m3oc4rz5kp.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 31 2011, Manoj wrote:
>> How about setting CONFIG_MMC_RICOH_MMC?
>
> Yes Sir... that was already set.
> CONFIG_MMC_RICOH_MMC=y

Ah, I think MMC_RICOH_MMC needs to know about this new PCI ID too.
I don't know whether that code knows how to turn off the MMC controller
on this model, though.

Please try this patch:

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index bd80f63..0852046 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2758,6 +2758,9 @@ static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
+
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C823, ricoh_mmc_fixup_r5c832);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C823, ricoh_mmc_fixup_r5c832);
 #endif /*CONFIG_MMC_RICOH_MMC*/
 
 #if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 11fd381..9ec3316 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1535,6 +1535,7 @@
 #define PCI_DEVICE_ID_RICOH_RL5C476	0x0476
 #define PCI_DEVICE_ID_RICOH_RL5C478	0x0478
 #define PCI_DEVICE_ID_RICOH_R5C822	0x0822
+#define PCI_DEVICE_ID_RICOH_R5C823	0x0823
 #define PCI_DEVICE_ID_RICOH_R5C832	0x0832
 #define PCI_DEVICE_ID_RICOH_R5C843	0x0843


and post dmesg of the result, as well as whether it worked.

We're trying the 0x832 disable method on an 0x823 controller, so I don't
know whether that'll work.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
