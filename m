Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab0IQNLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:11:33 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:32791 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752298Ab0IQNLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:11:31 -0400
Message-ID: <4C93690E.7000806@bspu.unibel.by>
Date: Fri, 17 Sep 2010 16:11:42 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b6pre) Gecko/20100902 SeaMonkey/2.1b1pre
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: pci: Re: #2 (Re: More modaliases + patchtool))
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au>
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------030708090104050202050107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030708090104050202050107
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Sorry, I'm too disseminated. Same, signed.

Rusty Russell wrote:


> I think the best way to split this patch is by bus type.  Drop the #ifdef's
> if you think it's a good idea, do some compile testing, then forward to the
> specific maintainers for each type.  I'm happy to do that for you if you
> want (though these kind of patches are Morton-worthy IMHO).

About compile testing: I build all possible modules for x86 (32 & 64) on my
builds (distro-like) to reduse various PC configuration. Basic version of this
script used before.

Are I must check bools vs. tristates or just look to C-code?

I prepare PCI patch without checking for bools. All staging modules looks
unstrict (not walking deep) to relating with PCI. All normal modules is strict
PCI. I keep #ifdef in staging only. Also 2 new modules coming from linux-next
branch (1+1 - strict and unstrict), second attachment.

PS Are the better to inline patches vs. attachment?

-- 
WBR, Dzianis Kahanovich AKA Denis Kaganovich, http://mahatma.bspu.unibel.by/


--------------030708090104050202050107
Content-Type: text/plain;
 name="mods-pci.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mods-pci.patch"

Fix lost PCI modaliases

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>

--- linux-2.6.36-rc4-git3/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c	2010-09-17 12:30:29.000000000 +0300
+++ b/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c	2010-09-17 12:38:40.552737804 +0300
@@ -512,6 +512,9 @@ MODULE_AUTHOR("Hiroshi Miura <miura@da-c
 MODULE_DESCRIPTION("Cpufreq driver for Cyrix MediaGX and NatSemi Geode");
 MODULE_LICENSE("GPL");
 
+
+MODULE_DEVICE_TABLE(pci, gx_chipset_tbl);
+
 module_init(cpufreq_gx_init);
 module_exit(cpufreq_gx_exit);
 
--- linux-2.6.36-rc4-git3/drivers/dma/pch_dma.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/dma/pch_dma.c	2010-09-17 12:38:44.102591039 +0300
@@ -949,6 +949,9 @@ static void __exit pch_dma_exit(void)
 	pci_unregister_driver(&pch_dma_driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, pch_dma_id_table);
+
 module_init(pch_dma_init);
 module_exit(pch_dma_exit);
 
--- linux-2.6.36-rc4-git3/drivers/gpu/drm/i810/i810_drv.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/gpu/drm/i810/i810_drv.c	2010-09-17 12:38:45.012486229 +0300
@@ -89,6 +89,9 @@ static void __exit i810_exit(void)
 	drm_exit(&driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, pciidlist);
+
 module_init(i810_init);
 module_exit(i810_exit);
 
--- linux-2.6.36-rc4-git3/drivers/gpu/drm/i830/i830_drv.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/gpu/drm/i830/i830_drv.c	2010-09-17 12:38:45.034555412 +0300
@@ -100,6 +100,9 @@ static void __exit i830_exit(void)
 	drm_exit(&driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, pciidlist);
+
 module_init(i830_init);
 module_exit(i830_exit);
 
--- linux-2.6.36-rc4-git3/drivers/gpu/drm/mga/mga_drv.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/gpu/drm/mga/mga_drv.c	2010-09-17 12:38:45.050928774 +0300
@@ -100,6 +100,9 @@ static void __exit mga_exit(void)
 	drm_exit(&driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, pciidlist);
+
 module_init(mga_init);
 module_exit(mga_exit);
 
--- linux-2.6.36-rc4-git3/drivers/gpu/drm/r128/r128_drv.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/gpu/drm/r128/r128_drv.c	2010-09-17 12:38:45.067342225 +0300
@@ -102,6 +102,9 @@ static void __exit r128_exit(void)
 	drm_exit(&driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, pciidlist);
+
 module_init(r128_init);
 module_exit(r128_exit);
 
--- linux-2.6.36-rc4-git3/drivers/gpu/drm/savage/savage_drv.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/gpu/drm/savage/savage_drv.c	2010-09-17 12:38:45.084696946 +0300
@@ -80,6 +80,9 @@ static void __exit savage_exit(void)
 	drm_exit(&driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, pciidlist);
+
 module_init(savage_init);
 module_exit(savage_exit);
 
--- linux-2.6.36-rc4-git3/drivers/gpu/drm/sis/sis_drv.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/gpu/drm/sis/sis_drv.c	2010-09-17 12:38:45.112711105 +0300
@@ -108,6 +108,9 @@ static void __exit sis_exit(void)
 	drm_exit(&driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, pciidlist);
+
 module_init(sis_init);
 module_exit(sis_exit);
 
--- linux-2.6.36-rc4-git3/drivers/gpu/drm/tdfx/tdfx_drv.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/gpu/drm/tdfx/tdfx_drv.c	2010-09-17 12:38:45.196631648 +0300
@@ -76,6 +76,9 @@ static void __exit tdfx_exit(void)
 	drm_exit(&driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, pciidlist);
+
 module_init(tdfx_init);
 module_exit(tdfx_exit);
 
--- linux-2.6.36-rc4-git3/drivers/gpu/drm/via/via_drv.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/gpu/drm/via/via_drv.c	2010-09-17 12:38:45.292629401 +0300
@@ -88,6 +88,9 @@ static void __exit via_exit(void)
 	drm_exit(&driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, pciidlist);
+
 module_init(via_init);
 module_exit(via_exit);
 
--- linux-2.6.36-rc4-git3/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c	2010-09-17 12:38:45.364383102 +0300
@@ -781,6 +781,9 @@ static void __exit vmwgfx_exit(void)
 	drm_exit(&driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, vmw_pci_id_list);
+
 module_init(vmwgfx_init);
 module_exit(vmwgfx_exit);
 
--- linux-2.6.36-rc4-git3/drivers/i2c/busses/scx200_acb.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/i2c/busses/scx200_acb.c	2010-09-17 12:38:47.445753894 +0300
@@ -653,5 +653,8 @@ static void __exit scx200_acb_cleanup(vo
 	mutex_unlock(&scx200_acb_list_mutex);
 }
 
+
+MODULE_DEVICE_TABLE(pci, scx200_pci);
+
 module_init(scx200_acb_init);
 module_exit(scx200_acb_cleanup);
--- linux-2.6.36-rc4-git3/drivers/media/dvb/mantis/hopper_cards.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/media/dvb/mantis/hopper_cards.c	2010-09-17 12:38:51.187348039 +0300
@@ -268,6 +268,9 @@ static void __devexit hopper_exit(void)
 	return pci_unregister_driver(&hopper_pci_driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, hopper_pci_table);
+
 module_init(hopper_init);
 module_exit(hopper_exit);
 
--- linux-2.6.36-rc4-git3/drivers/media/dvb/mantis/mantis_cards.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/media/dvb/mantis/mantis_cards.c	2010-09-17 12:38:51.201361079 +0300
@@ -298,6 +298,9 @@ static void __devexit mantis_exit(void)
 	return pci_unregister_driver(&mantis_pci_driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, mantis_pci_table);
+
 module_init(mantis_init);
 module_exit(mantis_exit);
 
--- linux-2.6.36-rc4-git3/drivers/media/dvb/ttpci/budget-patch.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/media/dvb/ttpci/budget-patch.c	2010-09-17 12:38:51.231761563 +0300
@@ -664,6 +664,9 @@ static struct saa7146_extension budget_e
 	.irq_func       = ttpci_budget_irq10_handler,
 };
 
+
+MODULE_DEVICE_TABLE(pci, pci_tbl);
+
 module_init(budget_patch_init);
 module_exit(budget_patch_exit);
 
--- linux-2.6.36-rc4-git3/drivers/media/video/stradis.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/media/video/stradis.c	2010-09-17 12:38:51.607895138 +0300
@@ -2209,5 +2209,8 @@ static void __exit stradis_exit(void)
 	printk(KERN_INFO "stradis: module cleanup complete\n");
 }
 
+
+MODULE_DEVICE_TABLE(pci, stradis_pci_tbl);
+
 module_init(stradis_init);
 module_exit(stradis_exit);
--- linux-2.6.36-rc4-git3/drivers/parisc/superio.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/parisc/superio.c	2010-09-17 12:38:56.221711538 +0300
@@ -513,5 +513,8 @@ static void __exit superio_exit(void)
 	pci_unregister_driver(&superio_driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, superio_tbl);
+
 module_init(superio_modinit);
 module_exit(superio_exit);
--- linux-2.6.36-rc4-git3/drivers/pci/ioapic.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/pci/ioapic.c	2010-09-17 12:38:56.262393634 +0300
@@ -123,5 +123,8 @@ static void __exit ioapic_exit(void)
 	pci_unregister_driver(&ioapic_driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, ioapic_devices);
+
 module_init(ioapic_init);
 module_exit(ioapic_exit);
--- linux-2.6.36-rc4-git3/drivers/serial/mfd.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/serial/mfd.c	2010-09-17 12:38:58.265303502 +0300
@@ -1491,6 +1491,9 @@ static void __exit hsu_pci_exit(void)
 	kfree(phsu);
 }
 
+
+MODULE_DEVICE_TABLE(pci, pci_ids);
+
 module_init(hsu_pci_init);
 module_exit(hsu_pci_exit);
 
--- linux-2.6.36-rc4-git3/drivers/spi/dw_spi_pci.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/spi/dw_spi_pci.c	2010-09-17 12:38:58.652691529 +0300
@@ -164,6 +164,9 @@ static void __exit mrst_spi_exit(void)
 	pci_unregister_driver(&dw_spi_driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, pci_ids);
+
 module_init(mrst_spi_init);
 module_exit(mrst_spi_exit);
 
--- linux-2.6.36-rc4-git3/drivers/uio/uio_sercos3.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/uio/uio_sercos3.c	2010-09-17 12:39:03.099643106 +0300
@@ -236,6 +236,9 @@ static void __exit sercos3_exit_module(v
 	pci_unregister_driver(&sercos3_pci_driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, sercos3_pci_ids);
+
 module_init(sercos3_init_module);
 module_exit(sercos3_exit_module);
 
--- linux-2.6.36-rc4-git3/drivers/video/i810/i810_main.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/video/i810/i810_main.c	2010-09-17 12:39:05.272728173 +0300
@@ -2220,4 +2220,7 @@ module_exit(i810fb_exit);
 
 #endif /* MODULE */
 
+
+MODULE_DEVICE_TABLE(pci, i810fb_pci_tbl);
+
 module_init(i810fb_init);
--- linux-2.6.36-rc4-git3/drivers/video/sstfb.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/video/sstfb.c	2010-09-17 12:39:05.542940314 +0300
@@ -1511,6 +1511,9 @@ static void __devexit sstfb_exit(void)
 }
 
 
+
+MODULE_DEVICE_TABLE(pci, sstfb_id_tbl);
+
 module_init(sstfb_init);
 module_exit(sstfb_exit);
 
--- linux-2.6.36-rc4-git3/drivers/video/sunxvr2500.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/video/sunxvr2500.c	2010-09-17 12:39:05.632422590 +0300
@@ -265,6 +265,9 @@ static void __exit s3d_exit(void)
 	pci_unregister_driver(&s3d_driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, s3d_pci_table);
+
 module_init(s3d_init);
 module_exit(s3d_exit);
 
--- linux-2.6.36-rc4-git3/drivers/video/sunxvr500.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/video/sunxvr500.c	2010-09-17 12:39:05.708587535 +0300
@@ -449,6 +449,9 @@ static void __exit e3d_exit(void)
 	pci_unregister_driver(&e3d_driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, e3d_pci_table);
+
 module_init(e3d_init);
 module_exit(e3d_exit);
 
--- linux-2.6.36-rc4-git3/drivers/video/vermilion/vermilion.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/video/vermilion/vermilion.c	2010-09-17 12:39:05.835126408 +0300
@@ -1177,6 +1177,9 @@ void vmlfb_unregister_subsys(struct vml_
 
 EXPORT_SYMBOL_GPL(vmlfb_unregister_subsys);
 
+
+MODULE_DEVICE_TABLE(pci, vml_ids);
+
 module_init(vmlfb_init);
 module_exit(vmlfb_cleanup);
 
--- linux-2.6.36-rc4-git3/drivers/staging/sm7xx/smtcfb.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/staging/sm7xx/smtcfb.c	2010-09-17 12:39:02.072627718 +0300
@@ -1135,6 +1135,11 @@ static void __exit smtcfb_exit(void)
 	pci_unregister_driver(&smtcfb_driver);
 }
 
+
+#ifdef CONFIG_PCI
+MODULE_DEVICE_TABLE(pci, smtcfb_pci_table);
+#endif
+
 module_init(smtcfb_init);
 module_exit(smtcfb_exit);
 
--- linux-2.6.36-rc4-git3/drivers/staging/vme/boards/vme_vmivme7805.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/staging/vme/boards/vme_vmivme7805.c	2010-09-17 12:39:02.368818072 +0300
@@ -118,6 +118,11 @@ MODULE_DESCRIPTION("VMIVME-7805 board su
 MODULE_AUTHOR("Arthur Benilov <arthur.benilov@iba-group.com>");
 MODULE_LICENSE("GPL");
 
+
+#ifdef CONFIG_PCI
+MODULE_DEVICE_TABLE(pci, vmic_ids);
+#endif
+
 module_init(vmic_init);
 module_exit(vmic_exit);
 
--- linux-2.6.36-rc4-git3/drivers/staging/vme/bridges/vme_ca91cx42.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c	2010-09-17 12:39:02.390100661 +0300
@@ -1836,5 +1836,10 @@ module_param(geoid, int, 0);
 MODULE_DESCRIPTION("VME driver for the Tundra Universe II VME bridge");
 MODULE_LICENSE("GPL");
 
+
+#ifdef CONFIG_PCI
+MODULE_DEVICE_TABLE(pci, ca91cx42_ids);
+#endif
+
 module_init(ca91cx42_init);
 module_exit(ca91cx42_exit);
--- linux-2.6.36-rc4-git3/drivers/staging/vme/bridges/vme_tsi148.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/staging/vme/bridges/vme_tsi148.c	2010-09-17 12:39:02.406718051 +0300
@@ -2637,5 +2637,10 @@ module_param(geoid, int, 0);
 MODULE_DESCRIPTION("VME driver for the Tundra Tempe VME bridge");
 MODULE_LICENSE("GPL");
 
+
+#ifdef CONFIG_PCI
+MODULE_DEVICE_TABLE(pci, tsi148_ids);
+#endif
+
 module_init(tsi148_init);
 module_exit(tsi148_exit);

--------------030708090104050202050107
Content-Type: text/plain;
 name="mods-pci_next_2010917.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mods-pci_next_2010917.patch"

Fix lost PCI modaliases (next)

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>

--- linux-2.6.36-rc4-next-20100917/drivers/usb/otg/langwell_otg.c	2010-09-17 13:11:34.646802996 +0300
+++ b/drivers/usb/otg/langwell_otg.c	2010-09-17 13:17:14.765649883 +0300
@@ -2399,6 +2399,11 @@ static int __init langwell_otg_init(void
 {
 	return pci_register_driver(&otg_pci_driver);
 }
+
+#ifdef CONFIG_PCI
+MODULE_DEVICE_TABLE(pci, pci_ids);
+#endif
+
 module_init(langwell_otg_init);
 
 static void __exit langwell_otg_cleanup(void)
--- linux-2.6.36-rc4-next-20100917/drivers/misc/pch_phub.c	2010-09-17 13:11:33.476802996 +0300
+++ b/drivers/misc/pch_phub.c	2010-09-17 13:17:19.873954434 +0300
@@ -710,6 +710,9 @@ static void __exit pch_phub_pci_exit(voi
 	pci_unregister_driver(&pch_phub_driver);
 }
 
+
+MODULE_DEVICE_TABLE(pci, pch_phub_pcidev_id);
+
 module_init(pch_phub_pci_init);
 module_exit(pch_phub_pci_exit);
 

--------------030708090104050202050107--
