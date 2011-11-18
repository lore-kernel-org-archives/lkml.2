Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab1KRH14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 02:27:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab1KRH1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 02:27:55 -0500
Date: Fri, 18 Nov 2011 08:27:29 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: hdoyu@nvidia.com
Cc: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Hiro Sugawara <hsugawara@nvidia.com>,
        Krishna Reddy <vdumpa@nvidia.com>
Subject: Re: [PATCH 2/3] ARM: iommu: tegra2: Initial support for GART driver
Message-ID: <20111118072729.GC20125@avionic-0098.mockup.avionic-design.de>
References: <1321527667-12923-1-git-send-email-hdoyu@nvidia.com>
 <1321527667-12923-3-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
Content-Disposition: inline
In-Reply-To: <1321527667-12923-3-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:fXz+OtF0bj3o2wJ0PeM1VOb0LgfDVeBCe07Uxx7OZKd
 C6+X4pNp8miGmFIAh6+aX5nxZsENAxZR9g05CyYDCD9k9DiuRW
 5gVV/VMC+OBD5q42up7dfLr6+/1CKg9kiUAxGS9d4HL0UF+41A
 GPJzMAZDIv0YbyhbcyY0Q7NWhbaNrEPW3L/w9fjvSkzrtc+zdG
 RxZyAmS6ACxGZnHMeVyMOiYk8Pxw7FW1ibPNQffdPOjVipIf9e
 4FXfkQJNGQcwugXKFWJGU9S9ZPKAdTBdOR/aF5r+SSt+QdC1cE
 eHUIMW+aGBEapsa7k1e/XHhRXLA/9jOLljVgJIzNeOXGTQn28Q
 kC1BLaWZuv/V149oZ+//WmQbxbkxVlG6WJRCRP+LyVnUi+4uwz
 I3O5fHA3xiA/CEKm1lTavscvYyNC+W4BXk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* hdoyu@nvidia.com wrote:
> From: Hiroshi DOYU <hdoyu@nvidia.com>
>=20
> Tegra 2 IOMMU H/W dependent part, GART (Graphics Address Relocation
> Table). This is one of the tegra_iovmm_device to register to the upper
> tegra IOVMM framework. This supports only single virtual address
> space(tegra_iovmm_domain), and manages a simple 1-to-1 mapping
> H/W translation pagetable.

I know I'm nitpicking, but this has inconsistent spelling for "Tegra" again.

> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> Cc: Hiro Sugawara <hsugawara@nvidia.com>
> Cc: Krishna Reddy <vdumpa@nvidia.com>
> ---
>  drivers/iommu/Kconfig      |   10 ++
>  drivers/iommu/Makefile     |    1 +
>  drivers/iommu/tegra-gart.c |  357 ++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 368 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/iommu/tegra-gart.c
>=20
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 487d1ee..7f342e8 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -133,6 +133,16 @@ config OMAP_IOMMU_DEBUG
> =20
> =20
>  # Tegra IOMMU support
> +config TEGRA_IOVMM_GART
> +	bool "Enable I/O virtual memory manager for GART"
> +	depends on ARCH_TEGRA_2x_SOC
> +	default y
> +	select TEGRA_IOVMM
> +	help
> +	  Enables support for remapping discontiguous physical memory
> +	  shared with the operating system into contiguous I/O virtual
> +	  space through the GART (Graphics Address Relocation Table)
> +	  hardware included on Tegra SoCs.
> =20
>  config TEGRA_IOVMM
>  	bool

I think you should move TEGRA_IOVMM_GART below TEGRA_IOVMM. Also, is it not
possible to build this as a module?

> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index 365eefb..4b61b05 100644
> --- a/drivers/iommu/Makefile
> +++ b/drivers/iommu/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_OMAP_IOMMU) +=3D omap-iommu.o
>  obj-$(CONFIG_OMAP_IOVMM) +=3D omap-iovmm.o
>  obj-$(CONFIG_OMAP_IOMMU_DEBUG) +=3D omap-iommu-debug.o
>  obj-$(CONFIG_TEGRA_IOVMM) +=3D tegra-iovmm.o
> +obj-$(CONFIG_TEGRA_IOVMM_GART) +=3D tegra-gart.o
> diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
> new file mode 100644
> index 0000000..24f893b
> --- /dev/null
> +++ b/drivers/iommu/tegra-gart.c
> @@ -0,0 +1,357 @@
> +/*
> + * Tegra I/O VMM implementation for GART devices in Tegra and Tegra 2 se=
ries
> + * systems-on-a-chip.
> + *
> + * Copyright (c) 2010-2011, NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but W=
ITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License alo=
ng
> + * with this program; if not, write to the Free Software Foundation, Inc=
=2E,
> + * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>
> +#include <linux/slab.h>
> +#include <linux/vmalloc.h>
> +#include <linux/mm.h>
> +#include <linux/io.h>
> +
> +#include <asm/cacheflush.h>
> +
> +#include <mach/iovmm.h>
> +
> +#define GART_CONFIG		0x24
> +#define GART_ENTRY_ADDR		0x28
> +#define GART_ENTRY_DATA		0x2c
> +
> +#define VMM_NAME "iovmm-gart"
> +#define DRIVER_NAME "tegra_gart"
> +
> +#define GART_PAGE_SHIFT		12
> +#define GART_PAGE_SIZE		(1 << GART_PAGE_SHIFT)
> +#define GART_PAGE_MASK		(~(GART_PAGE_SIZE - 1))
> +
> +struct gart_device {
> +	void __iomem		*regs;
> +	u32			*savedata;
> +	u32			page_count; /* total remappable size */
> +	tegra_iovmm_addr_t	iovmm_base; /* offset to apply to vmm_area */
> +	spinlock_t		pte_lock;
> +	struct tegra_iovmm_device iovmm;
> +	struct tegra_iovmm_domain domain;
> +	bool			enable;
> +};
> +
> +static inline void __gart_set_pte(struct gart_device *gart,
> +				tegra_iovmm_addr_t offs, u32 pte)
> +{
> +	writel(offs, gart->regs + GART_ENTRY_ADDR);
> +	writel(pte, gart->regs + GART_ENTRY_DATA);
> +	/*
> +	 * Any interaction between any block on PPSB and a block on
> +	 * APB or AHB must have these barriers to ensure the APB/AHB
> +	 * bus transaction is complete before initiating activity on
> +	 * the PPSB block.
> +	 */
> +	wmb();
> +}
> +
> +static inline void gart_set_pte(struct gart_device *gart,
> +				tegra_iovmm_addr_t offs, u32 pte)
> +{
> +	spin_lock(&gart->pte_lock);
> +
> +	__gart_set_pte(gart, offs, pte);
> +
> +	spin_unlock(&gart->pte_lock);
> +}
> +
> +static int gart_map(struct tegra_iovmm_domain *, struct tegra_iovmm_area=
 *);
> +static void gart_unmap(struct tegra_iovmm_domain *,
> +	struct tegra_iovmm_area *, bool);
> +static void gart_map_pfn(struct tegra_iovmm_domain *,
> +	struct tegra_iovmm_area *, tegra_iovmm_addr_t, unsigned long);
> +static struct tegra_iovmm_domain *gart_alloc_domain(
> +	struct tegra_iovmm_device *, struct tegra_iovmm_client *);
> +
> +static int gart_probe(struct platform_device *);
> +static int gart_remove(struct platform_device *);
> +static int gart_suspend(struct tegra_iovmm_device *dev);
> +static void gart_resume(struct tegra_iovmm_device *dev);
> +
> +
> +static struct tegra_iovmm_device_ops tegra_iovmm_gart_ops =3D {
> +	.map		=3D gart_map,
> +	.unmap		=3D gart_unmap,
> +	.map_pfn	=3D gart_map_pfn,
> +	.alloc_domain	=3D gart_alloc_domain,
> +	.suspend	=3D gart_suspend,
> +	.resume		=3D gart_resume,
> +};
> +
> +static struct platform_driver tegra_iovmm_gart_drv =3D {
> +	.probe		=3D gart_probe,
> +	.remove		=3D gart_remove,
> +	.driver		=3D {
> +		.name	=3D DRIVER_NAME,
> +	},
> +};
> +

You should probably move both of these structures to the end of the file so
you can get rid of the prototypes above.

> +static int gart_suspend(struct tegra_iovmm_device *dev)
> +{
> +	struct gart_device *gart =3D container_of(dev, struct gart_device, iovm=
m);
> +	unsigned int i;
> +	unsigned long reg;
> +
> +	if (!gart)
> +		return -ENODEV;

gart (or dev for that matter) can never actually be NULL here.

> +
> +	if (!gart->enable)
> +		return 0;
> +
> +	spin_lock(&gart->pte_lock);
> +	reg =3D gart->iovmm_base;
> +	for (i =3D 0; i < gart->page_count; i++) {
> +		writel(reg, gart->regs + GART_ENTRY_ADDR);
> +		gart->savedata[i] =3D readl(gart->regs + GART_ENTRY_DATA);
> +		dmb();
> +		reg +=3D GART_PAGE_SIZE;
> +	}
> +	spin_unlock(&gart->pte_lock);
> +	return 0;
> +}
> +
> +static void do_gart_setup(struct gart_device *gart, const u32 *data)
> +{
> +	unsigned long reg;
> +	unsigned int i;
> +
> +	reg =3D gart->iovmm_base;
> +	for (i =3D 0; i < gart->page_count; i++) {
> +		__gart_set_pte(gart, reg, data ? data[i] : 0);
> +		reg +=3D GART_PAGE_SIZE;
> +	}
> +
> +	writel(1, gart->regs + GART_CONFIG);
> +}
> +
> +static void gart_resume(struct tegra_iovmm_device *dev)
> +{
> +	struct gart_device *gart =3D container_of(dev, struct gart_device, iovm=
m);
> +
> +	if (!gart || !gart->enable || (gart->enable && !gart->savedata))
> +		return;

Same here.

> +
> +	spin_lock(&gart->pte_lock);
> +	do_gart_setup(gart, gart->savedata);
> +	spin_unlock(&gart->pte_lock);
> +}
> +
> +static int gart_remove(struct platform_device *pdev)
> +{
> +	struct gart_device *gart =3D platform_get_drvdata(pdev);
> +
> +	if (!gart)
> +		return 0;
> +

I don't think this can happen here either.

> +	if (gart->enable)
> +		writel(0, gart->regs + GART_CONFIG);
> +
> +	gart->enable =3D 0;
> +	platform_set_drvdata(pdev, NULL);
> +	tegra_iovmm_unregister(&gart->iovmm);
> +	if (gart->savedata)
> +		vfree(gart->savedata);
> +	if (gart->regs)
> +		iounmap(gart->regs);
> +	kfree(gart);
> +	return 0;
> +}
> +
> +static int gart_probe(struct platform_device *pdev)
> +{
> +	struct gart_device *gart;
> +	struct resource *res, *res_remap;
> +	void __iomem *gart_regs;
> +	int e;
> +
> +	if (!pdev) {
> +		pr_err(DRIVER_NAME ": platform_device required\n");
> +		return -ENODEV;
> +	}

This check can be dropped.

> +
> +	if (PAGE_SHIFT !=3D GART_PAGE_SHIFT) {
> +		pr_err(DRIVER_NAME ": GART and CPU page size must match\n");
> +		return -ENXIO;
> +	}

This should probably be checked at build time using BUILD_BUG_ON().

> +
> +	/* the GART memory aperture is required */
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	res_remap =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +
> +	if (!res || !res_remap) {
> +		pr_err(DRIVER_NAME ": GART memory aperture expected\n");
> +		return -ENXIO;
> +	}
> +	gart =3D kzalloc(sizeof(*gart), GFP_KERNEL);
> +	if (!gart) {
> +		pr_err(DRIVER_NAME ": failed to allocate tegra_iovmm_device\n");
> +		return -ENOMEM;
> +	}
> +
> +	gart_regs =3D ioremap_wc(res->start, res->end - res->start + 1);

resource_size(res)

> +	if (!gart_regs) {
> +		pr_err(DRIVER_NAME ": failed to remap GART registers\n");
> +		e =3D -ENXIO;
> +		goto fail;
> +	}
> +
> +	gart->iovmm.name =3D VMM_NAME;
> +	gart->iovmm.ops =3D &tegra_iovmm_gart_ops;
> +	gart->iovmm.pgsize_bits =3D GART_PAGE_SHIFT;
> +	spin_lock_init(&gart->pte_lock);
> +
> +	platform_set_drvdata(pdev, gart);
> +
> +	e =3D tegra_iovmm_register(&gart->iovmm);
> +	if (e)
> +		goto fail;
> +
> +	e =3D tegra_iovmm_domain_init(&gart->domain, &gart->iovmm,
> +		(tegra_iovmm_addr_t)res_remap->start,
> +		(tegra_iovmm_addr_t)res_remap->end + 1);

Why "end + 1"?

> +	if (e)
> +		goto fail;
> +
> +	gart->regs =3D gart_regs;
> +	gart->iovmm_base =3D (tegra_iovmm_addr_t)res_remap->start;
> +	gart->page_count =3D res_remap->end - res_remap->start + 1;

resource_size(res_remap)

> +	gart->page_count >>=3D GART_PAGE_SHIFT;
> +
> +	gart->savedata =3D vmalloc(sizeof(u32) * gart->page_count);
> +	if (!gart->savedata) {
> +		pr_err(DRIVER_NAME ": failed to allocate context save area\n");
> +		e =3D -ENOMEM;
> +		goto fail;
> +	}
> +
> +	spin_lock(&gart->pte_lock);
> +
> +	do_gart_setup(gart, NULL);
> +	gart->enable =3D 1;
> +
> +	spin_unlock(&gart->pte_lock);

Is the lock required here? Nothing else should be using the device until
after the probe function returns 0.

Also, wouldn't it be safer to move this complete setup code before the call
to tegra_iovmm_register()?

> +	return 0;
> +
> +fail:
> +	if (gart_regs)
> +		iounmap(gart_regs);
> +	if (gart && gart->savedata)
> +		vfree(gart->savedata);
> +	kfree(gart);
> +	return e;
> +}
> +
> +static int __devinit gart_init(void)
> +{
> +	return platform_driver_register(&tegra_iovmm_gart_drv);
> +}
> +
> +static void __exit gart_exit(void)
> +{
> +	return platform_driver_unregister(&tegra_iovmm_gart_drv);
> +}

Gratuitous "return".

> +
> +#define GART_PTE(_pfn) (0x80000000ul | ((_pfn) << PAGE_SHIFT))
> +
> +
> +static int gart_map(struct tegra_iovmm_domain *domain,
> +	struct tegra_iovmm_area *iovma)
> +{
> +	struct gart_device *gart =3D
> +		container_of(domain, struct gart_device, domain);
> +	unsigned long gart_page, count;
> +	unsigned int i;
> +
> +	gart_page =3D iovma->iovm_start;
> +	count =3D iovma->iovm_length >> GART_PAGE_SHIFT;
> +
> +	for (i =3D 0; i < count; i++) {
> +		unsigned long pfn;
> +
> +		pfn =3D iovma->ops->lock_makeresident(iovma, i << PAGE_SHIFT);
> +		if (!pfn_valid(pfn))
> +			goto fail;
> +
> +		gart_set_pte(gart, gart_page, GART_PTE(pfn));
> +		gart_page +=3D GART_PAGE_SIZE;
> +	}
> +
> +	return 0;
> +
> +fail:
> +	spin_lock(&gart->pte_lock);
> +	while (i--) {
> +		iovma->ops->release(iovma, i << PAGE_SHIFT);
> +		gart_page -=3D GART_PAGE_SIZE;
> +		__gart_set_pte(gart, gart_page, 0);
> +	}
> +	spin_unlock(&gart->pte_lock);
> +
> +	return -ENOMEM;
> +}
> +
> +static void gart_unmap(struct tegra_iovmm_domain *domain,
> +	struct tegra_iovmm_area *iovma, bool decommit)
> +{
> +	struct gart_device *gart =3D
> +		container_of(domain, struct gart_device, domain);
> +	unsigned long gart_page, count;
> +	unsigned int i;
> +
> +	count =3D iovma->iovm_length >> GART_PAGE_SHIFT;
> +	gart_page =3D iovma->iovm_start;
> +
> +	spin_lock(&gart->pte_lock);
> +	for (i =3D 0; i < count; i++) {
> +		if (iovma->ops && iovma->ops->release)
> +			iovma->ops->release(iovma, i << PAGE_SHIFT);
> +
> +		__gart_set_pte(gart, gart_page, 0);
> +		gart_page +=3D GART_PAGE_SIZE;
> +	}
> +	spin_unlock(&gart->pte_lock);
> +}
> +
> +static void gart_map_pfn(struct tegra_iovmm_domain *domain,
> +	struct tegra_iovmm_area *iovma, tegra_iovmm_addr_t offs,
> +	unsigned long pfn)
> +{
> +	struct gart_device *gart =3D
> +		container_of(domain, struct gart_device, domain);
> +
> +	BUG_ON(!pfn_valid(pfn));
> +
> +	gart_set_pte(gart, offs, GART_PTE(pfn));
> +}
> +
> +static struct tegra_iovmm_domain *gart_alloc_domain(
> +	struct tegra_iovmm_device *dev, struct tegra_iovmm_client *client)
> +{
> +	struct gart_device *gart =3D container_of(dev, struct gart_device, iovm=
m);
> +	return &gart->domain;
> +}

All of these functions should go before the platform_driver code.

> +
> +subsys_initcall(gart_init);

module_init()?

> +module_exit(gart_exit);
> --=20
> 1.7.0.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20

--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7GCOEACgkQZ+BJyKLjJp+fDQCfaNMoscAMlFX1PiuEcAjG/sKM
WycAoLDuupffHKEQlIdT9esQ7SJHDuJz
=lX/q
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--
