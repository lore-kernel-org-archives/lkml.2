Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1LEDEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 22:04:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622Ab1LEDEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 22:04:41 -0500
Date: Mon, 5 Dec 2011 14:04:13 +1100
From: NeilBrown <neilb@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        MyungJoo Ham <myungjoo.ham@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Mike Lockwood <lockwood@android.com>,
        Arve =?ISO-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111205140413.0d2c5382@notabene.brown>
In-Reply-To: <20111201113449.GD2915@opensource.wolfsonmicro.com>
References: <201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<201111281753.45287.arnd@arndb.de>
	<CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
	<20111130135847.68a6e4c6@notabene.brown>
	<CAJ0PZbRpoz+uK4QUAO4RG5bhsSpNvm5U-ROtbduXhnFTLMZ1VQ@mail.gmail.com>
	<20111201095633.700e2923@notabene.brown>
	<20111130231740.GA25340@opensource.wolfsonmicro.com>
	<20111130232529.GB3220@core.coreip.homeip.net>
	<20111201162144.187ecca3@notabene.brown>
	<20111201113449.GD2915@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vAXeqlh/RSwvm/.WYo6cGOJ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/vAXeqlh/RSwvm/.WYo6cGOJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Dec 2011 11:34:50 +0000 Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> On Thu, Dec 01, 2011 at 04:21:44PM +1100, NeilBrown wrote:
> > On Wed, 30 Nov 2011 15:25:29 -0800 Dmitry Torokhov
>=20
> > > Physical jack does not have to map 1:1 on logical jack. So 1 physical
> > > docking connector can be represented by 1 logical video connector, li=
ne
> > > in, line out, microphone and maybe else.
>=20
> > That is just what I was thinking :-)
>=20
> > It seems that a "connector" could be modelled as a set of binary switch=
es,
> > one for each service that is exported (or imported? ... "communicated" =
maybe)
> > through the connector.  When a cable (or dock) is plugged in, some numb=
er of
> > these switches are all switched on concurrently.  When it is unplugged =
they
> > are all switched off.
>=20
> > How strongly do we need this understanding of a "group" to be?
>=20
> It's useful to userspace to know that the grouping is there, and it's
> also useful to be able to say that the overall object that was inserted
> into the connector is whatever.  That could be done by grouping a bunch
> of other objects together.
>=20
> > Mark says:
>=20
> > > We also need some way to group things together so that we can underst=
and
> > > that we've got a single connector that can detect multiple things (eg,
> > > understanding that a cable hsa audio and video capability).
>=20
> > It isn't immediately obvious why this is the case.  There is no guarant=
ee
> > that I want to route audio and video in the same direction.  The best y=
ou can
> > probably get is a heuristic that both should be routed to the most rece=
ntly
> > available destination.
> > But again, maybe I'm missing something important.   I guess the helpful=
 piece
> > of information is: How exactly would this knowledge of grouping be used?
>=20
> Being able to provide useful default behaviour is an important win in
> itself, and in many embedded cases the end user has no access to this
> sort of policy anyway (consider smartphones and tablets).  You can
> probably do much better than you suggest above - for example, if the
> device connected is an AV cable then it's more likely that you want to
> treat it as a block to be routed together than if the device connected
> is a docking station.  You might also choose to do things like
> remembering the configurations used with particular cables and restoring
> them when reconnected - for example, distinguishing between a car dock
> and a desktop docking station.
>=20
> > One case I am thinking of is the twl4030 driver (a multi-function devic=
e for
> > power, usb, audio, battery charge etc).
> > The battery charger needs to know when the usb device gets a cable plug=
ged in
> > so that it can start charging.
> > It currently creates a link essentially by using a global variable.
>=20
> This is the sort of device that MyungJoo is taking about in a lot of his
> examples.

I just came across another example which is conceptually similar but
different enough to be worth mentioning I think ... see below.

> > Using a 'switch', the twl-core module could allocate a switch and pass =
it to
> > the usb module for sending notification and to the bci module for recei=
ving
> > them.  Whether it passes down a number which is later turned into a poi=
nter,
> > or whether it sends down the raw pointer, is just an implementation det=
ail.
>=20
> We really want something a bit more involved in the USB frameworks for
> the specific example of USB stuff (which is being worked on) - ideally
> we should be communicating information about how much current the host
> allows to be drawn throughout the system.
>=20

Sounds like a job for the 'regulator' framework - but that is a guess based
on not looking very deeply, so I'm probably wrong :-)


> > If the switch needs to be exported to user-space then someone needs to
> > provide a name for it.  I suspect the common-parent would be the obvious
> > choice, or the board file.
>=20
> Common parents often don't exist - it's not unusual for multiple devices
> to be involved in the detection of accessories.  Assuming a straight
> tree structure is very dangerous in the embedded context.  Board
> assigned naming does seem reasonable to me, though.

When I used the term "common-parent", I meant to mean that if there was no
obvious parent in a device-tree sense, then the "board" was the default
common parent.  I think we agree on this.


>=20
> > Just to be clear, the functionality that I see a 'switch' supporting is:
>=20
> > For the owner:
> >   - int switch_allocate(void)
> >   - void switch_export(int switchnum, char *name)
> >      This creates a device which appears in sysfs and has a 'state'
> >      attribute which responds to 'poll' requests so a process can find
> >      out about changes.
>=20
> > For the notifier:
> >   - void switch_set_state(int switchnum, bool value)
> >           This sets the state and notifies all notifiees (listeners).
>=20
> I think we do want something which lets us say "this is a cable of
> type X" so that we can report the difference between otherwise identical
> cables as in the car/desktop dock example I mentioned above.

I think you are saying that you might have two "cables" which connect up the
same sets of signals but are "different" somehow.  One connects to a car,
the other to a desk-top dock.
How is that difference detected by the hardware?  Presumably some switch?
So this is just one more binary switch to export to who-ever needs to know
(presumably user-space) ???


Anyway, my other example.

My GTA04 has a wifi chip connected to an mmc port.  The wifi chip has a
separate regulator that can be powered up/down independently of everything
else.
So when I apply power I need a way to tell the mmc driver to scan the bus.
It expects this information to come via a GPIO which has an associated IRQ.
But I don't have a physical gpio to give it.

So this is a case where one driver (the rfkill driver) needs to signal
another driver (the mmc driver) to tell it that a new device has become
available.  It hasn't been plugged in via a cable, it has be turned-on via a
regulator, but it is conceptually very similar.

I wrote a virtual gpio chip which I call gpio-inout because it provides pai=
rs
of gpios, an output paired with an input.  When the output is changed it
triggers an interrupt associated with the input, and the output is always
readable by the input.

So I create a pair, give one end to the mmc, the other to the rfkill.
Problem solved.

This is similar in some ways to the proposed 'switch' concept.  Where switch
uses a notifier chain, gpio-inout uses an IRQ to invoke code in a different
driver.

I don't think this is necessarily the "right" thing to do in all cases, but=
 I
present it as providing a hopefully-useful perspective on the problem space.

A cable port could be given a set of gpios.  It responds to a plug event by
setting most of the gpios to indicate the type and function of the cable, a=
nd
the pulses another gpio to say 'new cable'.  Most client would listen for
interrupts on that gpio, but could listen on a specific function-gpio if
needed.

One particular problem with this approach is that allocating IRQ numbers is
even more painful than allocating gpio number.  However that could be fixed=
 I
guess..

Anyway, food for thought for the interested.

NeilBrown


From: NeilBrown <neilb@suse.de>
Date: Fri, 2 Dec 2011 15:38:52 +1100
Subject: [PATCH] gpio-inout - virtual paired GPIO line.

A 'gpio-input' virtual chip provides pairs of GPIO lines.
The first of each pair (even offset) is an output which can be
set high or low.
The second is an input which reads the value of the paired output
and which generates an interrupt when the value transitions from
low to high.

This can be used to provide simple in-kernel signaling between
drivers, particular drivers that expect to get signals from GPIO
lines.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 8482a23..1d82f5c 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -489,4 +489,10 @@ config GPIO_TPS65910
 	help
 	  Select this option to enable GPIO driver for the TPS65910
 	  chip family.
+
+config GPIO_INOUT
+	bool "Virual InOut GPIO"
+	help
+	  Select this option for virtual gpios.
+
 endif
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index dbcb0bc..dcbe7e5 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -62,3 +62,4 @@ obj-$(CONFIG_GPIO_WM831X)	+=3D gpio-wm831x.o
 obj-$(CONFIG_GPIO_WM8350)	+=3D gpio-wm8350.o
 obj-$(CONFIG_GPIO_WM8994)	+=3D gpio-wm8994.o
 obj-$(CONFIG_GPIO_XILINX)	+=3D gpio-xilinx.o
+obj-$(CONFIG_GPIO_INOUT)	+=3D gpio-inout.o
diff --git a/drivers/gpio/gpio-inout.c b/drivers/gpio/gpio-inout.c
new file mode 100644
index 0000000..ecae821
--- /dev/null
+++ b/drivers/gpio/gpio-inout.c
@@ -0,0 +1,170 @@
+/*
+ * in-out gpios.
+ *
+ * An in-out gpio is a signaling mechanism between drivers and to
+ * user-space.
+ * A gpio-inout chip provides pairs of gpio lines that are connected.
+ * The even offsets are outputs that can be driven high or low.  The
+ * odd offsets are input that read the value from the previous gpio and
+ * can generate an interrupt.
+ * By exporting to sysfs they can allocate signaling with user-space too.
+ *
+ */
+
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/irq.h>
+#include <linux/gpio-inout.h>
+
+#include <linux/delay.h>
+
+struct inout_chip {
+	struct gpio_chip	gpio;
+	int			irq_base;
+	int			values[];
+};
+
+#define IS_OUT(gpio) (((gpio) & 1) =3D=3D 0)
+#define IS_IN(gpio) (((gpio) & 1) =3D=3D 1)
+
+static int gpio_inout_direction_output(struct gpio_chip *gchip, unsigned g=
pio,
+				       int val)
+{
+	struct inout_chip *chip =3D container_of(gchip, struct inout_chip, gpio);
+
+	if (IS_IN(gpio))
+		return -EINVAL;
+
+	chip->values[gpio/2] =3D val;
+	return 0;
+}
+
+static int gpio_inout_direction_input(struct gpio_chip *gchip, unsigned gp=
io)
+{
+	if (IS_OUT(gpio))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int gpio_inout_to_irq(struct gpio_chip *gchip, unsigned gpio)
+{
+	struct inout_chip *chip =3D container_of(gchip, struct inout_chip, gpio);
+
+	if (IS_OUT(gpio))
+		return -EINVAL;
+
+	return (gpio / 2) + chip->irq_base;
+}
+
+static void gpio_inout_set(struct gpio_chip *gchip, unsigned gpio, int val)
+{
+	struct inout_chip *chip =3D container_of(gchip, struct inout_chip, gpio);
+	int old;
+
+	if (IS_IN(gpio))
+		return;
+
+	old =3D chip->values[gpio/2];
+	chip->values[gpio/2] =3D val;
+	if (old !=3D val)
+		handle_nested_irq(chip->irq_base + gpio / 2);
+}
+
+static int gpio_inout_get(struct gpio_chip *gchip, unsigned gpio)
+{
+	struct inout_chip *chip =3D container_of(gchip, struct inout_chip, gpio);
+	return chip->values[gpio/2];
+}
+
+
+static inline void activate_irq(int irq)
+{
+#ifdef CONFIG_ARM
+	/* ARM requires an extra step to clear IRQ_NOREQUEST, which it
+	 * sets on behalf of every irq_chip.  Also sets IRQ_NOPROBE.
+	 */
+	set_irq_flags(irq, IRQF_VALID);
+#else
+	/* same effect on other architectures */
+	irq_set_noprobe(irq);
+#endif
+}
+
+static int __devinit gpio_inout_probe(struct platform_device *pdev)
+{
+	struct gpio_inout_platform_data *pdata =3D pdev->dev.platform_data;
+	struct inout_chip *chip;
+	int err;
+	int i;
+
+	err =3D -ENOMEM;
+	chip =3D kzalloc(sizeof(*chip) + pdata->npairs * sizeof(int),
+		       GFP_KERNEL);
+	if (!chip)
+		goto exit;
+
+	chip->gpio.label =3D "gpio_inout";
+	chip->gpio.names =3D pdata->names;
+	chip->gpio.ngpio =3D 2 * pdata->npairs;
+	chip->gpio.base =3D pdata->gpio_base;
+	chip->gpio.owner =3D THIS_MODULE;
+	chip->gpio.direction_output =3D gpio_inout_direction_output;
+	chip->gpio.direction_input =3D gpio_inout_direction_input;
+	chip->gpio.to_irq =3D gpio_inout_to_irq;
+	chip->gpio.set =3D gpio_inout_set;
+	chip->gpio.get =3D gpio_inout_get;
+	chip->gpio.dev =3D &pdev->dev;
+	chip->irq_base =3D pdata->irq_base;
+
+	err =3D gpiochip_add(&chip->gpio);
+	if (err)
+		goto exit;
+
+	for (i =3D 0; i < pdata->npairs; i++) {
+		irq_set_chip_and_handler(chip->irq_base + i,
+					 &dummy_irq_chip,
+					 handle_simple_irq);
+		irq_set_nested_thread(chip->irq_base + i, 1);
+		activate_irq(i);
+	}
+
+	if (pdata->setup)
+		pdata->setup(chip->gpio.base);
+	return 0;
+
+exit:
+	kfree(chip);
+	return err;
+}
+
+static int __devexit gpio_inout_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_driver gpio_inout_driver =3D {
+	.probe		=3D gpio_inout_probe,
+	.remove		=3D __devexit_p(gpio_inout_remove),
+	.driver.name	=3D "gpio-inout",
+	.driver.owner	=3D THIS_MODULE,
+};
+
+static int __init gpio_inout_init(void)
+{
+	return platform_driver_register(&gpio_inout_driver);
+}
+module_init(gpio_inout_init);
+
+static void __exit gpio_inout_exit(void)
+{
+	platform_driver_unregister(&gpio_inout_driver);
+}
+module_exit(gpio_inout_exit);
+
+MODULE_AUTHOR("NeilBrown <neilb@suse.de>");
+MODULE_DESCRIPTION("Virtual gpio pairs");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/gpio-inout.h b/include/linux/gpio-inout.h
new file mode 100644
index 0000000..07c6222
--- /dev/null
+++ b/include/linux/gpio-inout.h
@@ -0,0 +1,9 @@
+
+
+struct gpio_inout_platform_data {
+	int	npairs;
+	int	gpio_base;
+	int	irq_base;
+	const char **	names;
+	void (*setup)(unsigned gpio_base);
+};

--Sig_/vAXeqlh/RSwvm/.WYo6cGOJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtw0tDnsnt1WYoG5AQKbHg//Z1Q4/OWs5Z13QI/jJ9KU1RIFgbOsX02O
YNWELdDQhsUpisExqF9Twt7LacCSvBtag20d3ZpmWLCmm9O12YxRJHxQXiibEOHP
U/Zk0oaVEQrkHOgiYqxDBc30FEHj6zHJEOVItmkwyBHZGnFKtdCeBDMntvsgtw5Z
k0celDlToo19LYyHq0wMPey7wCOeYlx/LCffFHbiOwkHxjCYc7c2b+HUpN2pAjLq
O8oYODkpQVmolGQsH/PQn+I+xz6zVULt3ZVfmvgjy/HkjWotZBmOqHjjVXZmlsAb
lYb3hXvUytu7pA/ao1+leWvGySNvwtQP0bv4NLasLdXliRlURp4oqgsfgTrXgYxi
wafuMU6oiJixsgMAherxTB7Wcmdqr+U2eBKRRc7lcSD3sMdNbwN7pg1kKu4uL7XO
A9VAc7SvYqRjFlYUSVVkmcP7+QDGRf9ysq2O6/jGQkFMOGLyEV2tEOUeZEP/c+7k
Q1UU8ttmWAhDiF98cjSrueF36Z+OFiZfqev0eBqe8TzwulrWAlIofbBr+aEFeSY8
ds/rwTzA2Fm/+iOdKFa5rMnZqv7lwn0NsfQSrZP1r+fKtjH0JbVGvqvIAD2fq6Ij
/ZPDaLxr1wagk9ZcbTsfScLQqPNS4mc/1zvKudUd4002qbZUp/g8PWkv7NJ7ke4f
WGGxAr7YYzI=
=U6fz
-----END PGP SIGNATURE-----

--Sig_/vAXeqlh/RSwvm/.WYo6cGOJ--
