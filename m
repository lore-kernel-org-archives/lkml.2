Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0G0E7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 00:59:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28957 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0G0E7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 00:59:42 -0400
Message-ID: <4C4E6776.3010607@kernel.org>
Date: Mon, 26 Jul 2010 21:58:30 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Myron Stowe <myron.stowe@hp.com>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ipmi: print info for spmi and smbios path like acpi and
 pci
References: <4C4E3575.3020203@kernel.org>
In-Reply-To: <4C4E3575.3020203@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C4E67A0.0071,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


print out the reg spacing and size for spmi and smbios.
so bios guys could have idea to make them consistent.

also remove extra PFX on duplicating path.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/char/ipmi/ipmi_si_intf.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
@@ -2094,6 +2094,11 @@ static __devinit int try_init_spmi(struc
 	}
 	info->io.addr_data = spmi->addr.address;
 
+	pr_info("ipmi_si: SPMI: %s %#lx regsize %d spacing %d irq %d\n",
+		 (info->io.addr_type == IPMI_IO_ADDR_SPACE) ? "io" : "mem",
+		 info->io.addr_data, info->io.regsize, info->io.regspacing,
+		 info->irq);
+
 	if (add_smi(info))
 		kfree(info);
 
@@ -2372,6 +2377,11 @@ static __devinit void try_init_dmi(struc
 	if (info->irq)
 		info->irq_setup = std_irq_setup;
 
+	pr_info("ipmi_si: SMBIOS: %s %#lx regsize %d spacing %d irq %d\n",
+		 (info->io.addr_type == IPMI_IO_ADDR_SPACE) ? "io" : "mem",
+		 info->io.addr_data, info->io.regsize, info->io.regspacing,
+		 info->irq);
+
 	if (add_smi(info))
 		kfree(info);
 }
@@ -3066,7 +3076,7 @@ static int add_smi(struct smi_info *new_
 			si_to_str[new_smi->si_type]);
 	mutex_lock(&smi_infos_lock);
 	if (!is_new_interface(new_smi)) {
-		printk(KERN_CONT PFX "duplicate interface\n");
+		printk(KERN_CONT " duplicate interface\n");
 		rv = -EBUSY;
 		goto out_err;
 	}
