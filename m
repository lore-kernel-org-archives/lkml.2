Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab2IZUIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:08:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42871 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2IZUI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:08:28 -0400
Message-ID: <50636090.30909@pengutronix.de>
Date: Wed, 26 Sep 2012 22:07:44 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: akpm@linux-foundation.org, joe@perches.com, davem@davemloft.net,
        santosh.shilimkar@ti.com, grant.likely@secretlab.ca, balbi@ti.com,
        arnd@arndb.de, gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        robherring2@gmail.com, richard.zhao@freescale.com,
        B29397@freescale.com, alexander.shishkin@linux.intel.com,
        marex@denx.de, p.paneri@samsung.com,
        devicetree-discuss@lists.ozlabs.org,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] drivers: phy: add generic PHY framework
References: <1348671675-20830-1-git-send-email-kishon@ti.com>
In-Reply-To: <1348671675-20830-1-git-send-email-kishon@ti.com>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBCDC644CEBCFE787D4548759"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBCDC644CEBCFE787D4548759
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/26/2012 05:01 PM, Kishon Vijay Abraham I wrote:
> The PHY framework provides a set of API's for the PHY drivers to
> create/destroy a PHY and API's for the PHY users to obtain a reference =
to the
> PHY with or without using phandle. To obtain a reference to the PHY wit=
hout
> using phandle, the platform specfic intialization code (say from board =
file)
> should have already called phy_bind with the binding information. The b=
inding
> information consists of phy's device name, phy user device name and an =
index.
> The index is used when the same phy user binds to mulitple phys.
>=20
> PHY drivers should create the PHY by passing phy_descriptor that has
> describes the PHY (label, type etc..) and ops like init, exit, suspend,=
 resume,
> poweron, shutdown.
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

I suggest to talk to someone who is familiar with the linux-bus
abstraction. Adding devices, drivers, matching them and maintaining
binding information should not be reinvented.

See more comments inline.

> ---
> Did testing (phandle path) to some extent by hacking omap-usb2 to use t=
his
> new framework. (completely modifying omap-usb2 to use this framework wi=
ll
> take some time mostly because of the OTG stuff). Also perfomed non-dt
> testing by moving to a older kernel. Any kind of testing for this patch=
 is
> welcome :-)
>  MAINTAINERS             |    7 +
>  drivers/Kconfig         |    2 +
>  drivers/Makefile        |    2 +
>  drivers/phy/Kconfig     |   13 ++
>  drivers/phy/Makefile    |    5 +
>  drivers/phy/phy-core.c  |  445 +++++++++++++++++++++++++++++++++++++++=
++++++++
>  include/linux/phy/phy.h |  182 +++++++++++++++++++
>  7 files changed, 656 insertions(+)
>  create mode 100644 drivers/phy/Kconfig
>  create mode 100644 drivers/phy/Makefile
>  create mode 100644 drivers/phy/phy-core.c
>  create mode 100644 include/linux/phy/phy.h
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ea0519a..48f3cfb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3078,6 +3078,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel=
/git/arnd/asm-generic.git
>  S:	Maintained
>  F:	include/asm-generic
> =20
> +GENERIC PHY FRAMEWORK
> +M:	Kishon Vijay Abraham I <kishon@ti.com>
> +L:	linux-kernel@vger.kernel.org
> +S:	Supported
> +F:	drivers/phy/
> +F:	include/linux/phy/
> +
>  GENERIC UIO DRIVER FOR PCI DEVICES
>  M:	"Michael S. Tsirkin" <mst@redhat.com>
>  L:	kvm@vger.kernel.org
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 324e958..d289df5 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -154,4 +154,6 @@ source "drivers/vme/Kconfig"
> =20
>  source "drivers/pwm/Kconfig"
> =20
> +source "drivers/phy/Kconfig"
> +
>  endmenu
> diff --git a/drivers/Makefile b/drivers/Makefile
> index d64a0f7..e39252d 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -40,6 +40,8 @@ obj-y				+=3D char/
>  # gpu/ comes after char for AGP vs DRM startup
>  obj-y				+=3D gpu/
> =20
> +obj-y				+=3D phy/
> +
>  obj-$(CONFIG_CONNECTOR)		+=3D connector/
> =20
>  # i810fb and intelfb depend on char/agp/
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> new file mode 100644
> index 0000000..34f7077
> --- /dev/null
> +++ b/drivers/phy/Kconfig
> @@ -0,0 +1,13 @@
> +#
> +# PHY
> +#
> +
> +menuconfig GENERIC_PHY
> +	tristate "Generic PHY Support"
> +	help
> +	  Generic PHY support.
> +
> +	  This framework is designed to provide a generic interface for PHY
> +	  devices present in the kernel. This layer will have the generic
> +	  API by which phy drivers can create PHY using the phy framework and=

> +	  phy users can obtain reference to the PHY.
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> new file mode 100644
> index 0000000..9e9560f
> --- /dev/null
> +++ b/drivers/phy/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for the phy drivers.
> +#
> +
> +obj-$(CONFIG_GENERIC_PHY)	+=3D phy-core.o
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> new file mode 100644
> index 0000000..bf47a88
> --- /dev/null
> +++ b/drivers/phy/phy-core.c
> @@ -0,0 +1,445 @@
> +/*
> + * phy-core.c  --  Generic Phy framework.
> + *
> + * Copyright (C) 2012 Texas Instruments
> + *
> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
> + *
> + * This program is free software; you can redistribute  it and/or modi=
fy it
> + * under  the terms of  the GNU General  Public License as published b=
y the
> + * Free Software Foundation;  either version 2 of the  License, or (at=
 your
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/=
>.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/export.h>
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/of.h>
> +#include <linux/phy/phy.h>
> +
> +static struct class *phy_class;
> +static LIST_HEAD(phy_list);
> +static DEFINE_MUTEX(phy_list_mutex);
> +static LIST_HEAD(phy_bind_list);
> +
> +static void devm_phy_release(struct device *dev, void *res)
> +{
> +	struct phy *phy =3D *(struct phy **)res;
> +
> +	phy_put(phy);
> +}
> +
> +static int devm_phy_match(struct device *dev, void *res, void *match_d=
ata)
> +{
> +	return res =3D=3D match_data;
> +}
> +
> +static struct phy *phy_lookup(struct device *dev, u8 index)
> +{
> +	struct phy_bind *phy_bind =3D NULL;
> +
> +	list_for_each_entry(phy_bind, &phy_bind_list, list) {
> +		if (!(strcmp(phy_bind->dev_name, dev_name(dev))) &&
> +				phy_bind->index =3D=3D index)
> +			return phy_bind->phy;
> +	}
> +
> +	return ERR_PTR(-ENODEV);
> +}
> +
> +static struct phy *of_phy_lookup(struct device *dev, struct device_nod=
e *node)
> +{
> +	int index =3D 0;
> +	struct phy *phy;
> +	struct phy_bind *phy_map =3D NULL;
> +
> +	list_for_each_entry(phy_map, &phy_bind_list, list)
> +		if (!(strcmp(phy_map->dev_name, dev_name(dev))))
> +			index++;

This automatically index generation looks error prone to me. It might
differ from the "index" in the DT phandle.

> +
> +	list_for_each_entry(phy, &phy_list, head) {
> +		if (node !=3D phy->desc->of_node)
> +			continue;
> +
> +		phy_map =3D phy_bind(dev_name(dev), index, dev_name(&phy->dev));

Why does a lookup create a phy binding? From my point of view the lookup
function should do the lookup, the *_phy_get should create the binding.

Again - you should really have a look at the linux "bus" subsystem. It's
used all over the kernel to create and maintain bindings of all sort of
driver/devices. I don't know how to integrate this into the phy
infrastructure, but I'm pretty sure it will fit.

> +		if (!IS_ERR(phy_map)) {
> +			phy_map->phy =3D phy;
> +			phy_map->auto_bind =3D true;
> +		}
> +
> +		return phy;
> +	}
> +
> +	return ERR_PTR(-ENODEV);
> +}
> +
> +/**
> + * devm_phy_get - lookup and obtain a reference to a phy.
> + * @dev: device that requests this phy
> + * @index: the index of the phy
> + *
> + * Gets the phy using phy_get(), and associates a device with it using=

> + * devres. On driver detach, release function is invoked on the devres=
 data,
> + * then, devres data is freed.
> + */
> +struct phy *devm_phy_get(struct device *dev, u8 index)
> +{
> +	struct phy **ptr, *phy;
> +
> +	ptr =3D devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return NULL;
> +
> +	phy =3D phy_get(dev, index);
> +	if (!IS_ERR(phy)) {
> +		*ptr =3D phy;
> +		devres_add(dev, ptr);
> +	} else
> +		devres_free(ptr);

Please use { } in else, too.

> +
> +	return phy;
> +}
> +EXPORT_SYMBOL_GPL(devm_phy_get);
> +
> +/**
> + * devm_phy_put - release the PHY
> + * @dev: device that wants to release this phy
> + * @phy: the phy returned by devm_phy_get()
> + *
> + * destroys the devres associated with this phy and invokes phy_put
> + * to release the phy.
> + */
> +void devm_phy_put(struct device *dev, struct phy *phy)
> +{
> +	int r;
> +
> +	r =3D devres_destroy(dev, devm_phy_release, devm_phy_match, phy);
> +	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
> +}
> +EXPORT_SYMBOL_GPL(devm_phy_put);
> +
> +/**
> + * devm_of_phy_get - lookup and obtain a reference to a phy by phandle=

> + * @dev: device that requests this phy
> + * @phandle: name of the property holding the phy phandle value
> + * @index: the index of the phy
> + *
> + * Returns the phy driver associated with the given phandle value,
> + * after getting a refcount to it or -ENODEV if there is no such phy o=
r
> + * -EPROBE_DEFER if there is a phandle to the phy, but the device is
> + * not yet loaded. While at that, it also associates the device with t=
he
> + * phy using devres. On driver detach, release function is invoked on =
the
> + * devres data, then, devres data is freed.
> + */
> +struct phy *devm_of_phy_get(struct device *dev, const char *phandle, u=
8 index)
> +{
> +	struct phy *phy =3D NULL, **ptr;
> +	struct device_node *node;
> +
> +	if (!dev->of_node) {
> +		dev_dbg(dev, "device does not have a device node entry\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	node =3D of_parse_phandle(dev->of_node, phandle, index);

Where's the corresponding of_node_put()?

> +	if (!node) {
> +		dev_dbg(dev, "failed to get %s phandle in %s node\n", phandle,
> +			dev->of_node->full_name);
> +		return ERR_PTR(-ENODEV);
> +	}
> +
> +	ptr =3D devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr) {
> +		dev_dbg(dev, "failed to allocate memory for devres\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	mutex_lock(&phy_list_mutex);
> +
> +	phy =3D of_phy_lookup(dev, node);
> +	if (IS_ERR(phy) || !phy->dev.class ||
> +			!try_module_get(phy->dev.class->owner)) {

If I understand the code correctly, you are now locking the phy-core
module itself. Which is not needed, as you cannot unload a module while
someone uses the exported symbols.

I was talking about to lock the module that provides the individual phy
driver implementaton. I'm using this to lock the phy module:

	try_module_get(phy->dev->driver->owner)

> +		phy =3D ERR_PTR(-EPROBE_DEFER);
> +		devres_free(ptr);
> +		goto err0;
> +	}
> +
> +	*ptr =3D phy;
> +	devres_add(dev, ptr);
> +
> +	get_device(&phy->dev);
> +
> +err0:
> +	mutex_unlock(&phy_list_mutex);
> +
> +	return phy;
> +}
> +EXPORT_SYMBOL_GPL(devm_of_phy_get);
> +
> +/**
> + * phy_get - lookup and obtain a reference to a phy.
> + * @dev: device that requests this phy
> + * @index: the index of the phy
> + *
> + * Returns the phy driver, after getting a refcount to it; or
> + * -ENODEV if there is no such phy.  The caller is responsible for
> + * calling phy_put() to release that count.
> + */
> +struct phy *phy_get(struct device *dev, u8 index)
> +{
> +	struct phy *phy =3D NULL;
> +
> +	mutex_lock(&phy_list_mutex);
> +
> +	phy =3D phy_lookup(dev, index);
> +	if (IS_ERR(phy) || !phy->dev.class ||
> +			!try_module_get(phy->dev.class->owner)) {
> +		dev_dbg(dev, "unable to obtain phy\n");
> +		goto err0;
> +	}
> +
> +	get_device(&phy->dev);
> +
> +err0:
> +	mutex_unlock(&phy_list_mutex);
> +
> +	return phy;
> +}
> +EXPORT_SYMBOL_GPL(phy_get);
> +
> +/**
> + * phy_put - release the PHY
> + * @phy: the phy returned by phy_get()
> + *
> + * Releases a refcount the caller received from phy_get().
> + */
> +void phy_put(struct phy *phy)
> +{
> +	if (phy) {
> +		put_device(&phy->dev);

You are not allowed to deref phy->dev after the put.

> +		module_put(phy->dev.class->owner);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(phy_put);
> +
> +/**
> + * phy_create - create a new phy
> + * @dev: device that is creating the new phy
> + * @desc: descriptor of the phy
> + *
> + * Called to create a phy using phy framework.
> + */
> +struct phy *phy_create(struct device *dev, struct phy_descriptor *desc=
)
> +{
> +	int ret;
> +	struct phy *phy;
> +	struct phy_bind *phy_bind;
> +	const char *devname =3D NULL;
> +
> +	if (!dev || !desc) {
> +		dev_err(dev, "no descriptor/device provided for PHY\n");
> +		ret =3D -EINVAL;
> +		goto err0;
> +	}
> +
> +	if (!desc->ops) {
> +		dev_err(dev, "no PHY ops provided\n");
> +		ret =3D -EINVAL;
> +		goto err0;
> +	}
> +
> +	phy =3D kzalloc(sizeof(*phy), GFP_KERNEL);
> +	if (!phy) {
> +		dev_err(dev, "no memory for PHY\n");
> +		ret =3D -ENOMEM;
> +		goto err0;
> +	}
> +
> +	devname =3D dev_name(dev);
> +	device_initialize(&phy->dev);
> +	phy->desc =3D desc;
> +	phy->dev.class =3D phy_class;
> +	phy->dev.parent =3D dev;
> +	ret =3D dev_set_name(&phy->dev, "%s", devname);
> +	if (ret)
> +		goto err1;
> +
> +	mutex_lock(&phy_list_mutex);
> +	list_for_each_entry(phy_bind, &phy_bind_list, list)
> +		if (!(strcmp(phy_bind->phy_dev_name, devname)))
> +			phy_bind->phy =3D phy;
> +
> +	list_add_tail(&phy->head, &phy_list);
> +
> +	ret =3D device_add(&phy->dev);
> +	if (ret)
> +		goto err2;
> +
> +	mutex_unlock(&phy_list_mutex);
> +
> +	return phy;
> +
> +err2:
> +	list_del(&phy->head);
> +	phy_bind->phy =3D NULL;
> +	mutex_unlock(&phy_list_mutex);
> +
> +err1:
> +	put_device(&phy->dev);
> +	kfree(phy);
> +
> +err0:
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(phy_create);
> +
> +/**
> + * phy_destroy - destroy the phy
> + * @phy: the phy to be destroyed
> + *
> + * Called to destroy the phy.
> + */
> +void phy_destroy(struct phy *phy)
> +{
> +	struct phy_bind *phy_bind;
> +
> +	mutex_lock(&phy_list_mutex);
> +	list_for_each_entry(phy_bind, &phy_bind_list, list) {
> +		if (phy_bind->phy =3D=3D phy)
> +			phy_bind->phy =3D NULL;
> +
> +		if (phy_bind->auto_bind) {
> +			list_del(&phy_bind->list);
> +			kfree(phy_bind);
> +		}
> +	}
> +
> +	list_del(&phy->head);
> +	mutex_unlock(&phy_list_mutex);
> +
> +	device_unregister(&phy->dev);
> +}
> +EXPORT_SYMBOL_GPL(phy_destroy);
> +
> +/**
> + * phy_bind - bind the phy and the controller that uses the phy
> + * @dev_name: the device name of the device that will bind to the phy
> + * @index: index to specify the port number
> + * @phy_dev_name: the device name of the phy
> + *
> + * Fills the phy_bind structure with the dev_name and phy_dev_name. Th=
is will
> + * be used when the phy driver registers the phy and when the controll=
er
> + * requests this phy.
> + *
> + * To be used by platform specific initialization code.
> + */
> +struct phy_bind *phy_bind(const char *dev_name, u8 index,
> +				const char *phy_dev_name)
> +{
> +	struct phy_bind *phy_bind;
> +
> +	phy_bind =3D kzalloc(sizeof(*phy_bind), GFP_KERNEL);
> +	if (!phy_bind) {
> +		pr_err("phy_bind(): No memory for phy_bind");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	phy_bind->dev_name =3D dev_name;
> +	phy_bind->phy_dev_name =3D phy_dev_name;
> +	phy_bind->index =3D index;
> +	phy_bind->auto_bind =3D false;
> +
> +	list_add_tail(&phy_bind->list, &phy_bind_list);
> +
> +	return phy_bind;
> +}
> +EXPORT_SYMBOL_GPL(phy_bind);

Why does this function return the phy_bind? Is it used outside of this
framework?

> +
> +static ssize_t phy_name_show(struct device *dev,
> +			     struct device_attribute *attr, char *buf)
> +{
> +	struct phy *phy;
> +
> +	phy =3D container_of(dev, struct phy, dev);
> +
> +	return sprintf(buf, "%s\n", phy->desc->label);
> +}
> +
> +static ssize_t phy_bind_show(struct device *dev,
> +			     struct device_attribute *attr, char *buf)
> +{
> +	struct phy_bind *phy_bind;
> +	struct phy *phy;
> +	char *p =3D buf;
> +	int len;
> +
> +	phy =3D container_of(dev, struct phy, dev);
> +
> +	list_for_each_entry(phy_bind, &phy_bind_list, list)
> +		if (phy_bind->phy =3D=3D phy)
> +			p +=3D sprintf(p, "%s %d\n", phy_bind->dev_name,
> +							phy_bind->index);

What about the one value per sysfs entry policy?

> +	len =3D (p - buf);
> +
> +	return len;
> +}
> +
> +static struct device_attribute phy_dev_attrs[] =3D {
> +	__ATTR(label, 0444, phy_name_show, NULL),
> +	__ATTR(bind, 0444, phy_bind_show, NULL),
> +	__ATTR_NULL,
> +};
> +
> +/**
> + * phy_release - release the phy
> + * @dev: the dev member within phy
> + *
> + * when the last reference to the device is removed; it is called
> + * from the embedded kobject as release method.
> + */
> +static void phy_release(struct device *dev)
> +{
> +	struct phy *phy;
> +
> +	phy =3D container_of(dev, struct phy, dev);
> +	dev_dbg(dev, "releasing '%s'\n", dev_name(dev));
> +	kfree(phy);
> +}
> +
> +static int __init phy_core_init(void)
> +{
> +	phy_class =3D class_create(THIS_MODULE, "phy");
> +	if (IS_ERR(phy_class)) {
> +		pr_err("failed to create phy class --> %ld\n",
> +			PTR_ERR(phy_class));
> +		return PTR_ERR(phy_class);
> +	}
> +
> +	phy_class->dev_release =3D phy_release;
> +	phy_class->dev_attrs =3D phy_dev_attrs;
> +	phy_class->owner =3D THIS_MODULE;
> +
> +	return 0;
> +}
> +subsys_initcall(phy_core_init);
> +
> +static void __exit phy_core_exit(void)
> +{
> +	class_destroy(phy_class);
> +}
> +module_exit(phy_core_exit);
> +
> +MODULE_DESCRIPTION("Generic Phy Framework");
> +MODULE_AUTHOR("Kishon Vijay Abraham I <kishon@ti.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> new file mode 100644
> index 0000000..6fc3f0a
> --- /dev/null
> +++ b/include/linux/phy/phy.h
> @@ -0,0 +1,182 @@
> +/*
> + * phy.h -- generic phy header file
> + *
> + * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.c=
om
> + * This program is free software; you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License as published b=
y
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __DRIVERS_PHY_H
> +#define __DRIVERS_PHY_H
> +
> +struct phy;
> +
> +/**
> + * struct phy_descriptor - structure that describes the PHY
> + * @label: label given to phy
> + * @type: specifies the phy type
> + * @of_node: device node of the phy
> + * @ops: function pointers for performing phy operations
> + */
> +struct phy_descriptor {
> +	const char		*label;

The label is only used to print in sysfs. Does it have another purpose?

> +	int			type;

What means type here? It seems to be unused in this code.

> +	struct device_node	*of_node;

Why do you need the *of_node here? The device that creates a phy already
has a of_node pointer.

> +	struct phy_ops		*ops;
> +};
> +
> +/**
> + * struct phy_ops - set of function pointers for performing phy operat=
ions
> + * @init: operation to be performed for initializing phy
> + * @exit: operation to be performed while exiting
> + * @suspend: suspending the phy
> + * @resume: resuming the phy
> + * @poweron: powering on the phy
> + * @shutdown: shutting down the phy
> + */
> +struct phy_ops {
> +	int	(*init)(struct phy_descriptor *desc);
> +	int	(*exit)(struct phy_descriptor *desc);
> +	int	(*suspend)(struct phy_descriptor *desc);
> +	int	(*resume)(struct phy_descriptor *desc);
> +	int	(*poweron)(struct phy_descriptor *desc);
> +	int	(*shutdown)(struct phy_descriptor *desc);
> +};
> +
> +/**
> + * struct phy - represent the phy device
> + * @desc: descriptor for the phy
> + * @head: to support multiple transceivers
> + */
> +struct phy {
> +	struct device		dev;
> +	struct phy_descriptor	*desc;
> +	struct list_head	head;
> +};
> +
> +/**
> + * struct phy_bind - represent the binding for the phy
> + * @dev_name: the device name of the device that will bind to the phy
> + * @phy_dev_name: the device name of the phy
> + * @index: used if a single controller uses multiple phys
> + * @auto_bind: tells if the binding is done explicitly from board file=
 or not
> + * @phy: reference to the phy
> + * @list: to maintain a linked list of the binding information
> + */
> +struct phy_bind {
> +	const char	*dev_name;
> +	const char	*phy_dev_name;
> +	u8		index;
> +	int		auto_bind:1;
> +	struct phy	*phy;
> +	struct list_head list;
> +};
> +
> +#if defined(CONFIG_GENERIC_PHY) || defined(CONFIG_GENERIC_PHY_MODULE)
> +extern struct phy *devm_phy_get(struct device *dev, u8 index);
> +extern void devm_phy_put(struct device *dev, struct phy *phy);
> +extern struct phy *devm_of_phy_get(struct device *dev, const char *pha=
ndle,
> +	u8 index);
> +extern struct phy *phy_get(struct device *dev, u8 index);
> +extern void phy_put(struct phy *phy);
> +extern struct phy *phy_create(struct device *dev, struct phy_descripto=
r *desc);
> +extern void phy_destroy(struct phy *phy);
> +extern struct phy_bind *phy_bind(const char *dev_name, u8 index,
> +				const char *phy_dev_name);
> +#else
> +static inline struct phy *devm_phy_get(struct device *dev, u8 index)
> +{
> +	return ERR_PTR(-EINVAL);
> +}
> +
> +static inline void devm_phy_put(struct device *dev, struct phy *phy)
> +{
> +}
> +
> +static inline struct phy *devm_of_phy_get(struct device *dev,
> +		const char *phandle, u8 index)
> +{
> +	return ERR_PTR(-EINVAL);
> +}
> +
> +static inline struct phy *phy_get(struct device *dev, u8 index)
> +{
> +	return ERR_PTR(-EINVAL);
> +}
> +
> +static inline void phy_put(struct phy *phy)
> +{
> +}
> +
> +static inline struct phy *phy_create(struct device *dev,
> +	struct phy_descriptor *desc)
> +{
> +	return ERR_PTR(-EINVAL);
> +}
> +
> +static inline void phy_destroy(struct phy *phy)
> +{
> +}
> +
> +static inline struct phy_bind *phy_bind(const char *dev_name, u8 index=
,
> +				const char *phy_dev_name)
> +{
> +}
> +#endif
> +
> +static inline int phy_init(struct phy *phy)
> +{
> +	if (phy->desc->ops->init)
> +		return phy->desc->ops->init(phy->desc);
> +
> +	return -EINVAL;
> +}
> +
> +static inline int phy_exit(struct phy *phy)
> +{
> +	if (phy->desc->ops->exit)
> +		return phy->desc->ops->exit(phy->desc);
> +
> +	return -EINVAL;
> +}
> +
> +static inline int phy_suspend(struct phy *phy)
> +{
> +	if (phy->desc->ops->suspend)
> +		return phy->desc->ops->suspend(phy->desc);
> +
> +	return -EINVAL;
> +}
> +
> +static inline int phy_resume(struct phy *phy)
> +{
> +	if (phy->desc->ops->resume)
> +		return phy->desc->ops->resume(phy->desc);
> +
> +	return -EINVAL;
> +}
> +
> +static inline int phy_poweron(struct phy *phy)
> +{
> +	if (phy->desc->ops->poweron)
> +		return phy->desc->ops->poweron(phy->desc);
> +
> +	return -EINVAL;
> +}
> +
> +static inline int phy_shutdown(struct phy *phy)
> +{
> +	if (phy->desc->ops->shutdown)
> +		return phy->desc->ops->shutdown(phy->desc);
> +}
> +#endif /* __DRIVERS_PHY_H */
>=20

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigBCDC644CEBCFE787D4548759
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBjYJMACgkQjTAFq1RaXHMOSgCfftfs+R7UC73wgMuBfblGIlaz
iboAnjNsMc+EfPUkRtP1jB4nya1wtONF
=u15Y
-----END PGP SIGNATURE-----

--------------enigBCDC644CEBCFE787D4548759--
