Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2LDNSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:18:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39312 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab2LDNR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:17:57 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "ivan.djelic@parrot.com" <ivan.djelic@parrot.com>
Subject: RE: [PATCH v2 3/3] mtd: nand: omap2: Support for hardware BCH error
 correction
Thread-Topic: [PATCH v2 3/3] mtd: nand: omap2: Support for hardware BCH
 error correction
Thread-Index: AQHNtzjXuTV6Me2Mjkybsf/6HC7XhZgCIZ8AgAaurAA=
Date: Tue, 4 Dec 2012 13:16:27 +0000
Deferred-Delivery: Tue, 4 Dec 2012 13:16:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA108A9@DBDE01.ent.ti.com>
References: <1351667307-447-1-git-send-email-avinashphilip@ti.com>
	 <1351667307-447-4-git-send-email-avinashphilip@ti.com>
 <1354278480.30168.116.camel@sauron.fi.intel.com>
In-Reply-To: <1354278480.30168.116.camel@sauron.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB4DI2Sp008861

On Fri, Nov 30, 2012 at 17:58:00, Artem Bityutskiy wrote:
> On Wed, 2012-10-31 at 12:38 +0530, Philip, Avinash wrote:
> > +static int erased_sector_bitflips(u_char *data, u_char *oob,
> > +               struct omap_nand_info *info)
> > +{
> > +       int flip_bits = 0, i;
> > +
> > +       for (i = 0; i < info->nand.ecc.size; i++) {
> > +               flip_bits += hweight8(~data[i]);
> > +               if (flip_bits > info->nand.ecc.strength)
> > +                       return 0;
> > +       }
> > +
> > +       for (i = 0; i < info->nand.ecc.bytes - 1; i++) {
> > +               flip_bits += hweight8(~oob[i]);
> > +               if (flip_bits > info->nand.ecc.strength)
> > +                       return 0;
> > +       }
> 
> Why do you need the second for loop?

BCH ecc is self protected & can correct bit flips in ecc bytes.
So here checking bit flips in read_ecc. I will rename variable
"oob" to "read_ecc"

Thanks
Avinash

> 
> -- 
> Best Regards,
> Artem Bityutskiy
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
