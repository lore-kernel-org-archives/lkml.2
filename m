Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab1HOPr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:47:57 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14224 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab1HOPry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:47:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 15 Aug 2011 08:47:30 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Belisko Marek <marek.belisko@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Aug 2011 08:47:27 -0700
Subject: RE: [RFC PATCH 08/12] gpio/tegra: Add device tree support
Thread-Topic: [RFC PATCH 08/12] gpio/tegra: Add device tree support
Thread-Index: AcxZnkYdJ8oj3aXGRPevQyYPr2/8kgBxCspg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA25048@HQMAIL01.nvidia.com>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
	<1313189697-21287-9-git-send-email-swarren@nvidia.com>
 <CAAfyv34kOtwjerB0gMhEKNTwGd9w-LCE52MCUuvzTyYkXLY-dg@mail.gmail.com>
In-Reply-To: <CAAfyv34kOtwjerB0gMhEKNTwGd9w-LCE52MCUuvzTyYkXLY-dg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7FFm4L3024747

Belisko Marek wrote at Saturday, August 13, 2011 3:49 AM:
> On Sat, Aug 13, 2011 at 12:54 AM, Stephen Warren <swarren@nvidia.com> wrote:
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > ---
> > Â drivers/gpio/gpio-tegra.c | Â  31 +++++++++++++++++++++++++++++++
> > Â 1 files changed, 31 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
...
> > +static void __init tegra_gpio_probe_dt(struct platform_device *pdev)
> > +{
> > + Â  Â  Â  const __be32 *gpios;
> > + Â  Â  Â  u32 gpioslen;
> > + Â  Â  Â  int i;
> > +
> > + Â  Â  Â  gpios = of_get_property(pdev->dev.of_node, "nvidia,gpios", &gpioslen);
> > + Â  Â  Â  if (gpios == NULL)
> > + Â  Â  Â  Â  Â  Â  Â  return;
> > +
> > + Â  Â  Â  gpioslen /= sizeof(*gpios);
> > + Â  Â  Â  for (i = 0; i < gpioslen; i++, gpios++) {
> > + Â  Â  Â  Â  Â  Â  Â  u32 gpio = be32_to_cpup(gpios);
> > + Â  Â  Â  Â  Â  Â  Â  dev_err(&pdev->dev, "Enabling GPIO %d\n", gpio);
>
> Is really necessary to print all enabled gpio's to console? Also seen
> same in pinmux probe.

Oops, that's certainly not necessary. That was debugging code, and I meant
to convert to dev_dbg before posting.

-- 
nvpublic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
