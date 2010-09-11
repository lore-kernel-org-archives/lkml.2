Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0IKDg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 23:36:29 -0400
Received: from claw.goop.org ([74.207.240.146]:56380 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005Ab0IKDg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 23:36:28 -0400
Message-ID: <4C8AF933.9060304@goop.org>
Date: Sat, 11 Sep 2010 13:36:19 +1000
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: mahatma@eu.by, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: #2 (Re: More modaliases + patchtool)
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au>
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 09/11/2010 12:14 PM, Rusty Russell wrote:
> On Thu, 19 Aug 2010 10:12:36 pm Dzianis Kahanovich wrote:
>> diff -pruN a/arch/ia64/hp/common/aml_nfw.c b/arch/ia64/hp/common/aml_nfw.c
>> --- a/arch/ia64/hp/common/aml_nfw.c	2010-08-02 01:11:14.000000000 +0300
>> +++ b/arch/ia64/hp/common/aml_nfw.c	2010-08-19 15:23:40.124764995 +0300
>> @@ -232,5 +232,10 @@ static void __exit aml_nfw_exit(void)
>>  	aml_nfw_remove_global_handler();
>>  }
>>  
>> +
>> +#ifdef CONFIG_ACPI
>> +MODULE_DEVICE_TABLE(acpi, aml_nfw_ids);
>> +#endif
>> +
>>  module_init(aml_nfw_init);
>>  module_exit(aml_nfw_exit);
> Hi Dzianis,
>
>    Sorry it took me so long to reply.  It looks very much like some of
> these cannot be modules anyway.  aml_nfw can't be (the Kconfig is a bool).
> Strange that it has an exit function!
>
>> diff -pruN a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
>> --- a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c	2010-08-19 15:20:56.064764994 +0300
>> +++ b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c	2010-08-19 15:23:40.254764992 +0300
>> @@ -554,6 +554,11 @@ static int __init mpc52xx_lpbfifo_init(v
>>  	pr_debug("Registering LocalPlus bus FIFO driver\n");
>>  	return of_register_platform_driver(&mpc52xx_lpbfifo_driver);
>>  }
>> +
>> +#ifdef CONFIG_OF
>> +MODULE_DEVICE_TABLE(of, mpc52xx_lpbfifo_match);
>> +#endif
>> +
>>  module_init(mpc52xx_lpbfifo_init);
>>  
>>  static void __exit mpc52xx_lpbfifo_exit(void)
>> diff -pruN a/arch/powerpc/platforms/83xx/suspend.c b/arch/powerpc/platforms/83xx/suspend.c
>> --- a/arch/powerpc/platforms/83xx/suspend.c	2010-08-19 15:20:56.064764994 +0300
>> +++ b/arch/powerpc/platforms/83xx/suspend.c	2010-08-19 15:23:40.364764995 +0300
>> @@ -437,4 +437,9 @@ static int pmc_init(void)
>>  	return of_register_platform_driver(&pmc_driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_OF
>> +MODULE_DEVICE_TABLE(of, pmc_match);
>> +#endif
>> +
>>  module_init(pmc_init);
>> diff -pruN a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
>> --- a/arch/powerpc/sysdev/axonram.c	2010-08-19 15:20:56.074764995 +0300
>> +++ b/arch/powerpc/sysdev/axonram.c	2010-08-19 15:23:40.514764994 +0300
>> @@ -363,6 +363,11 @@ axon_ram_exit(void)
>>  	unregister_blkdev(azfs_major, AXON_RAM_DEVICE_NAME);
>>  }
>>  
>> +
>> +#ifdef CONFIG_OF
>> +MODULE_DEVICE_TABLE(of, axon_ram_device_id);
>> +#endif
>> +
>>  module_init(axon_ram_init);
>>  module_exit(axon_ram_exit);
> These seem valid at a glance, but should go through the PowerPC maintainer.
>   
>> diff -pruN a/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c b/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
>> --- a/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c	2010-08-19 15:20:56.234765003 +0300
>> +++ b/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c	2010-08-19 15:23:40.564764991 +0300
>> @@ -512,6 +512,11 @@ MODULE_AUTHOR("Hiroshi Miura <miura@da-c
>>  MODULE_DESCRIPTION("Cpufreq driver for Cyrix MediaGX and NatSemi Geode");
>>  MODULE_LICENSE("GPL");
>>  
>> +
>> +#ifdef CONFIG_PCI
>> +MODULE_DEVICE_TABLE(pci, gx_chipset_tbl);
>> +#endif
>> +
>>  module_init(cpufreq_gx_init);
>>  module_exit(cpufreq_gx_exit);
>>  
>> diff -pruN a/drivers/block/swim3.c b/drivers/block/swim3.c
>> --- a/drivers/block/swim3.c	2010-08-19 15:20:56.344764984 +0300
>> +++ b/drivers/block/swim3.c	2010-08-19 15:23:40.954764998 +0300
>> @@ -1203,6 +1203,11 @@ int swim3_init(void)
>>  	return 0;
>>  }
>>  
>> +
>> +#ifdef CONFIG_OF
>> +MODULE_DEVICE_TABLE(of, swim3_match);
>> +#endif
>> +
>>  module_init(swim3_init)
>>  
>>  MODULE_LICENSE("GPL");
>> diff -pruN a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
>> --- a/drivers/block/xen-blkfront.c	2010-08-19 15:20:56.344764984 +0300
>> +++ b/drivers/block/xen-blkfront.c	2010-08-19 15:23:41.104764997 +0300
>> @@ -1306,6 +1306,9 @@ static int __init xlblk_init(void)
>>  
>>  	return xenbus_register_frontend(&blkfront);
>>  }
>> +
>> +MODULE_DEVICE_TABLE(xenbus, blkfront_ids);
>> +
>>  module_init(xlblk_init);
> This seems very logical.  Jeremy?

Looks OK.  What will the effect be?  Will it allow better module
auto-loading or something?

>> diff -pruN a/drivers/char/hw_random/pasemi-rng.c b/drivers/char/hw_random/pasemi-rng.c
>> --- a/drivers/char/hw_random/pasemi-rng.c	2010-08-19 15:20:56.354764978 +0300
>> +++ b/drivers/char/hw_random/pasemi-rng.c	2010-08-19 15:23:41.284764991 +0300
>> @@ -153,6 +153,11 @@ static int __init rng_init(void)
>>  {
>>  	return of_register_platform_driver(&rng_driver);
>>  }
>> +
>> +#ifdef CONFIG_OF
>> +MODULE_DEVICE_TABLE(of, rng_match);
>> +#endif
>> +
>>  module_init(rng_init);
> Do we really need all these #ifdef CONFIG_OF wrappers?
>
>>  static void __exit rng_exit(void)
>> diff -pruN a/drivers/char/sonypi.c b/drivers/char/sonypi.c
>> --- a/drivers/char/sonypi.c	2010-08-02 01:11:14.000000000 +0300
>> +++ b/drivers/char/sonypi.c	2010-08-19 15:23:41.374764992 +0300
>> @@ -1565,5 +1565,10 @@ static void __exit sonypi_exit(void)
>>  	printk(KERN_INFO "sonypi: removed.\n");
>>  }
>>  
>> +
>> +#ifdef CONFIG_ACPI
>> +MODULE_DEVICE_TABLE(acpi, sonypi_device_ids);
>> +#endif
>> +
>>  module_init(sonypi_init);
>>  module_exit(sonypi_exit);
>> diff -pruN a/drivers/char/sysrq.c b/drivers/char/sysrq.c
>> --- a/drivers/char/sysrq.c	2010-08-02 01:11:14.000000000 +0300
>> +++ b/drivers/char/sysrq.c	2010-08-19 15:23:41.444764991 +0300
>> @@ -799,4 +799,9 @@ static int __init sysrq_init(void)
>>  
>>  	return 0;
>>  }
>> +
>> +#ifdef CONFIG_INPUT
>> +MODULE_DEVICE_TABLE(input, sysrq_ids);
>> +#endif
>> +
>>  module_init(sysrq_init);
> Hmm, Dmitry?  Do we want this auto-loaded?
>
>> diff -pruN a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
>> --- a/drivers/crypto/amcc/crypto4xx_core.c	2010-08-19 15:20:56.384765007 +0300
>> +++ b/drivers/crypto/amcc/crypto4xx_core.c	2010-08-19 15:23:41.594764998 +0300
>> @@ -1300,6 +1300,11 @@ static void __exit crypto4xx_exit(void)
>>  	of_unregister_platform_driver(&crypto4xx_driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_OF
>> +MODULE_DEVICE_TABLE(of, crypto4xx_match);
>> +#endif
>> +
>>  module_init(crypto4xx_init);
>>  module_exit(crypto4xx_exit);
>>  
>> diff -pruN a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
>> --- a/drivers/dma/mpc512x_dma.c	2010-08-19 15:20:56.384765007 +0300
>> +++ b/drivers/dma/mpc512x_dma.c	2010-08-19 15:23:41.714764994 +0300
>> @@ -784,6 +784,11 @@ static int __init mpc_dma_init(void)
>>  {
>>  	return of_register_platform_driver(&mpc_dma_driver);
>>  }
>> +
>> +#ifdef CONFIG_OF
>> +MODULE_DEVICE_TABLE(of, mpc_dma_match);
>> +#endif
>> +
>>  module_init(mpc_dma_init);
>>  
>>  static void __exit mpc_dma_exit(void)
>> diff -pruN a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
>> --- a/drivers/dma/pch_dma.c	2010-08-19 15:24:05.484765021 +0300
>> +++ b/drivers/dma/pch_dma.c	2010-08-19 15:23:41.624764993 +0300
>> @@ -950,6 +950,11 @@ static void __exit pch_dma_exit(void)
>>  	pci_unregister_driver(&pch_dma_driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_PCI
>> +MODULE_DEVICE_TABLE(pci, pch_dma_id_table);
>> +#endif
>> +
>>  module_init(pch_dma_init);
>>  module_exit(pch_dma_exit);
>>  
>> diff -pruN a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
>> --- a/drivers/edac/ppc4xx_edac.c	2010-08-19 15:20:56.394765000 +0300
>> +++ b/drivers/edac/ppc4xx_edac.c	2010-08-19 15:23:41.864764986 +0300
>> @@ -1437,6 +1437,11 @@ ppc4xx_edac_exit(void)
>>  	of_unregister_platform_driver(&ppc4xx_edac_driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_OF
>> +MODULE_DEVICE_TABLE(of, ppc4xx_edac_match);
>> +#endif
>> +
>>  module_init(ppc4xx_edac_init);
>>  module_exit(ppc4xx_edac_exit);
>>  
>> diff -pruN a/drivers/gpu/drm/i810/i810_drv.c b/drivers/gpu/drm/i810/i810_drv.c
>> --- a/drivers/gpu/drm/i810/i810_drv.c	2010-08-19 15:20:56.414764981 +0300
>> +++ b/drivers/gpu/drm/i810/i810_drv.c	2010-08-19 15:23:41.924764989 +0300
>> @@ -89,6 +89,11 @@ static void __exit i810_exit(void)
>>  	drm_exit(&driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_PCI
>> +MODULE_DEVICE_TABLE(pci, pciidlist);
>> +#endif
>> +
>>  module_init(i810_init);
>>  module_exit(i810_exit);
>>  
>> diff -pruN a/drivers/gpu/drm/i830/i830_drv.c b/drivers/gpu/drm/i830/i830_drv.c
>> --- a/drivers/gpu/drm/i830/i830_drv.c	2010-08-19 15:20:56.414764981 +0300
>> +++ b/drivers/gpu/drm/i830/i830_drv.c	2010-08-19 15:23:41.944765010 +0300
>> @@ -100,6 +100,11 @@ static void __exit i830_exit(void)
>>  	drm_exit(&driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_PCI
>> +MODULE_DEVICE_TABLE(pci, pciidlist);
>> +#endif
>> +
>>  module_init(i830_init);
>>  module_exit(i830_exit);
>>  
>> diff -pruN a/drivers/gpu/drm/mga/mga_drv.c b/drivers/gpu/drm/mga/mga_drv.c
>> --- a/drivers/gpu/drm/mga/mga_drv.c	2010-08-19 15:20:56.424764989 +0300
>> +++ b/drivers/gpu/drm/mga/mga_drv.c	2010-08-19 15:23:41.954765003 +0300
>> @@ -100,6 +100,11 @@ static void __exit mga_exit(void)
>>  	drm_exit(&driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_PCI
>> +MODULE_DEVICE_TABLE(pci, pciidlist);
>> +#endif
>> +
>>  module_init(mga_init);
>>  module_exit(mga_exit);
>>  
>> diff -pruN a/drivers/gpu/drm/r128/r128_drv.c b/drivers/gpu/drm/r128/r128_drv.c
>> --- a/drivers/gpu/drm/r128/r128_drv.c	2010-08-19 15:20:56.454765003 +0300
>> +++ b/drivers/gpu/drm/r128/r128_drv.c	2010-08-19 15:23:41.974764991 +0300
>> @@ -102,6 +102,11 @@ static void __exit r128_exit(void)
>>  	drm_exit(&driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_PCI
>> +MODULE_DEVICE_TABLE(pci, pciidlist);
>> +#endif
>> +
>>  module_init(r128_init);
>>  module_exit(r128_exit);
>>  
>> diff -pruN a/drivers/gpu/drm/savage/savage_drv.c b/drivers/gpu/drm/savage/savage_drv.c
>> --- a/drivers/gpu/drm/savage/savage_drv.c	2010-08-02 01:11:14.000000000 +0300
>> +++ b/drivers/gpu/drm/savage/savage_drv.c	2010-08-19 15:23:41.994764993 +0300
>> @@ -80,6 +80,11 @@ static void __exit savage_exit(void)
>>  	drm_exit(&driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_PCI
>> +MODULE_DEVICE_TABLE(pci, pciidlist);
>> +#endif
>> +
>>  module_init(savage_init);
>>  module_exit(savage_exit);
>>  
>> diff -pruN a/drivers/gpu/drm/sis/sis_drv.c b/drivers/gpu/drm/sis/sis_drv.c
>> --- a/drivers/gpu/drm/sis/sis_drv.c	2010-08-19 15:20:56.474764991 +0300
>> +++ b/drivers/gpu/drm/sis/sis_drv.c	2010-08-19 15:23:42.004764994 +0300
>> @@ -108,6 +108,11 @@ static void __exit sis_exit(void)
>>  	drm_exit(&driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_PCI
>> +MODULE_DEVICE_TABLE(pci, pciidlist);
>> +#endif
>> +
>>  module_init(sis_init);
>>  module_exit(sis_exit);
>>  
>> diff -pruN a/drivers/gpu/drm/tdfx/tdfx_drv.c b/drivers/gpu/drm/tdfx/tdfx_drv.c
>> --- a/drivers/gpu/drm/tdfx/tdfx_drv.c	2010-08-02 01:11:14.000000000 +0300
>> +++ b/drivers/gpu/drm/tdfx/tdfx_drv.c	2010-08-19 15:23:42.024764996 +0300
>> @@ -76,6 +76,11 @@ static void __exit tdfx_exit(void)
>>  	drm_exit(&driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_PCI
>> +MODULE_DEVICE_TABLE(pci, pciidlist);
>> +#endif
>> +
>>  module_init(tdfx_init);
>>  module_exit(tdfx_exit);
>>  
>> diff -pruN a/drivers/gpu/drm/via/via_drv.c b/drivers/gpu/drm/via/via_drv.c
>> --- a/drivers/gpu/drm/via/via_drv.c	2010-08-02 01:11:14.000000000 +0300
>> +++ b/drivers/gpu/drm/via/via_drv.c	2010-08-19 15:23:42.034764997 +0300
>> @@ -88,6 +88,11 @@ static void __exit via_exit(void)
>>  	drm_exit(&driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_PCI
>> +MODULE_DEVICE_TABLE(pci, pciidlist);
>> +#endif
>> +
>>  module_init(via_init);
>>  module_exit(via_exit);
>>  
>> diff -pruN a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
>> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c	2010-08-19 15:20:56.484764992 +0300
>> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c	2010-08-19 15:23:42.044765004 +0300
>> @@ -781,6 +781,11 @@ static void __exit vmwgfx_exit(void)
>>  	drm_exit(&driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_PCI
>> +MODULE_DEVICE_TABLE(pci, vmw_pci_id_list);
>> +#endif
>> +
>>  module_init(vmwgfx_init);
>>  module_exit(vmwgfx_exit);
>>  
>> diff -pruN a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>> --- a/drivers/hid/hid-core.c	2010-08-19 15:20:56.484764992 +0300
>> +++ b/drivers/hid/hid-core.c	2010-08-19 15:23:42.244764996 +0300
>> @@ -1957,6 +1957,11 @@ static void __exit hid_exit(void)
>>  	bus_unregister(&hid_bus_type);
>>  }
>>  
>> +
>> +#ifdef CONFIG_HID
>> +MODULE_DEVICE_TABLE(hid, hid_hiddev_list);
>> +#endif
>> +
>>  module_init(hid_init);
>>  module_exit(hid_exit);
>>  
>> diff -pruN a/drivers/hwmon/ad7414.c b/drivers/hwmon/ad7414.c
>> --- a/drivers/hwmon/ad7414.c	2010-08-02 01:11:14.000000000 +0300
>> +++ b/drivers/hwmon/ad7414.c	2010-08-19 15:23:42.334765000 +0300
>> @@ -254,6 +254,11 @@ static int __init ad7414_init(void)
>>  {
>>  	return i2c_add_driver(&ad7414_driver);
>>  }
>> +
>> +#ifdef CONFIG_I2C
>> +MODULE_DEVICE_TABLE(i2c, ad7414_id);
>> +#endif
>> +
>>  module_init(ad7414_init);
>>  
>>  static void __exit ad7414_exit(void)
>> diff -pruN a/drivers/hwmon/adt7411.c b/drivers/hwmon/adt7411.c
>> --- a/drivers/hwmon/adt7411.c	2010-08-02 01:11:14.000000000 +0300
>> +++ b/drivers/hwmon/adt7411.c	2010-08-19 15:23:42.434764993 +0300
>> @@ -351,6 +351,11 @@ static int __init sensors_adt7411_init(v
>>  {
>>  	return i2c_add_driver(&adt7411_driver);
>>  }
>> +
>> +#ifdef CONFIG_I2C
>> +MODULE_DEVICE_TABLE(i2c, adt7411_id);
>> +#endif
>> +
>>  module_init(sensors_adt7411_init)
>>  
>>  static void __exit sensors_adt7411_exit(void)
>> diff -pruN a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
>> --- a/drivers/i2c/busses/i2c-ibm_iic.c	2010-08-19 15:20:56.504764994 +0300
>> +++ b/drivers/i2c/busses/i2c-ibm_iic.c	2010-08-19 15:23:42.814765003 +0300
>> @@ -824,5 +824,10 @@ static void __exit iic_exit(void)
>>  	of_unregister_platform_driver(&ibm_iic_driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_OF
>> +MODULE_DEVICE_TABLE(of, ibm_iic_match);
>> +#endif
>> +
>>  module_init(iic_init);
>>  module_exit(iic_exit);
>> diff -pruN a/drivers/i2c/busses/scx200_acb.c b/drivers/i2c/busses/scx200_acb.c
>> --- a/drivers/i2c/busses/scx200_acb.c	2010-08-19 15:24:05.484765021 +0300
>> +++ b/drivers/i2c/busses/scx200_acb.c	2010-08-19 15:23:42.664764994 +0300
>> @@ -654,5 +654,10 @@ static void __exit scx200_acb_cleanup(vo
>>  	mutex_unlock(&scx200_acb_list_mutex);
>>  }
>>  
>> +
>> +#ifdef CONFIG_PCI
>> +MODULE_DEVICE_TABLE(pci, scx200_pci);
>> +#endif
>> +
>>  module_init(scx200_acb_init);
>>  module_exit(scx200_acb_cleanup);
>> diff -pruN a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
>> --- a/drivers/ide/ide-pnp.c	2010-08-02 01:11:14.000000000 +0300
>> +++ b/drivers/ide/ide-pnp.c	2010-08-19 15:23:42.964764986 +0300
>> @@ -105,6 +105,11 @@ static void __exit pnpide_exit(void)
>>  	pnp_unregister_driver(&idepnp_driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_PNP
>> +MODULE_DEVICE_TABLE(pnp, idepnp_devices);
>> +#endif
>> +
>>  module_init(pnpide_init);
>>  module_exit(pnpide_exit);
>>  
>> diff -pruN a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
>> --- a/drivers/input/keyboard/hil_kbd.c	2010-08-19 15:20:56.534764997 +0300
>> +++ b/drivers/input/keyboard/hil_kbd.c	2010-08-19 15:23:43.254765003 +0300
>> @@ -591,5 +591,10 @@ static void __exit hil_dev_exit(void)
>>  	serio_unregister_driver(&hil_serio_drv);
>>  }
>>  
>> +
>> +#ifdef CONFIG_SERIO
>> +MODULE_DEVICE_TABLE(serio, hil_dev_ids);
>> +#endif
>> +
>>  module_init(hil_dev_init);
>>  module_exit(hil_dev_exit);
>> diff -pruN a/drivers/input/misc/sparcspkr.c b/drivers/input/misc/sparcspkr.c
>> --- a/drivers/input/misc/sparcspkr.c	2010-08-19 15:20:56.544765004 +0300
>> +++ b/drivers/input/misc/sparcspkr.c	2010-08-19 15:23:43.394764978 +0300
>> @@ -370,5 +370,10 @@ static void __exit sparcspkr_exit(void)
>>  	of_unregister_platform_driver(&grover_beep_driver);
>>  }
>>  
>> +
>> +#ifdef CONFIG_OF
>> +MODULE_DEVICE_TABLE(of, bbc_beep_match);
>> +#endif
>> +
>>  module_init(sparcspkr_init);
>>  module_exit(sparcspkr_exit);
>> diff -pruN a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c
>> --- a/drivers/input/serio/hil_mlc.c	2010-08-02 01:11:14.000000000 +0300
>> +++ b/drivers/input/serio/hil_mlc.c	2010-08-19 15:23:43.494765003 +0300
>> @@ -1010,5 +1010,10 @@ static void __exit hil_mlc_exit(void)
>>  	tasklet_kill(&hil_mlcs_tasklet);
>>  }
>>  
>> +
>> +#ifdef CONFIG_SERIO
>> +MODULE_DEVICE_TABLE(serio, hil_mlc_serio_id);
>> +#endif
>> +
>>  module_init(hil_mlc_init);
>>  module_exit(hil_mlc_exit);
>> diff -pruN a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
>> --- a/drivers/input/xen-kbdfront.c	2010-08-19 15:20:56.554764997 +0300
>> +++ b/drivers/input/xen-kbdfront.c	2010-08-19 15:23:43.754764993 +0300
>> @@ -354,6 +354,9 @@ static void __exit xenkbd_cleanup(void)
>>  	xenbus_unregister_driver(&xenkbd_driver);
>>  }
>>  
>> +
>> +MODULE_DEVICE_TABLE(xenbus, xenkbd_ids);
>> +
>>  module_init(xenkbd_init);
>>  module_exit(xenkbd_cleanup);
> This one, too, seems to make sense.

Yep.

Both Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

(and any other similar Xen/xenbus-related changes).

    J
