Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab2LDNWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:22:11 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39607 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab2LDNWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:22:05 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>
CC: "ivan.djelic@parrot.com" <ivan.djelic@parrot.com>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: RE: [PATCH v2 0/3] mtd: nand: OMAP: ELM error correction support
 for BCH ecc
Thread-Topic: [PATCH v2 0/3] mtd: nand: OMAP: ELM error correction support
 for BCH ecc
Thread-Index: AQHNtzjAYJXEaMIpjk+PG7tWZP2/spfqfEcAgAaEjeCAAudd0IABibAAgABzjZCADDxHAIAGr3dw
Date: Tue, 4 Dec 2012 13:20:50 +0000
Deferred-Delivery: Tue, 4 Dec 2012 13:20:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA108CE@DBDE01.ent.ti.com>
References: <1351667307-447-1-git-send-email-avinashphilip@ti.com>
	 <1352978534.2221.33.camel@sauron.fi.intel.com>
	 <518397C60809E147AF5323E0420B992E3E9EC70D@DBDE01.ent.ti.com>
	 <1353581032.2701.34.camel@sauron.fi.intel.com>
	 <518397C60809E147AF5323E0420B992E3E9EE329@DBDE01.ent.ti.com>
 <1354278498.30168.117.camel@sauron.fi.intel.com>
In-Reply-To: <1354278498.30168.117.camel@sauron.fi.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB4DMJAV008886

On Fri, Nov 30, 2012 at 17:58:18, Artem Bityutskiy wrote:
> On Thu, 2012-11-22 at 14:37 +0000, Philip, Avinash wrote:
> > Idea here is to make faster scanning of erased page without bit flips.
> > For omap nand driver ecc reported by hardware is non-zero and non
> > 0xff.
> > So comparing with the standard vector for erased page and skipping
> > error
> > correction for erased page without bit flips.
> 
> So you mean that when you read a page, and you see there are bit-flips,
> you start correcting them. But if you notice that the page is actually
> an erased page, you optimize this case by not running the correction
> machinery, but just filling the buffer with 0xFFs. Right?

Yes it is an optimization for erased page bit flip handling.
On erased page, ecc bytes not valid.  So no direct correction machinery
available for bit flips in erased page. Hence I was checking if any bit flips
reported in erased page. If bit flip present in erased page and falls under
correctable level, report the page with 0xff with correctable errors.


Thanks
Avinash

> > 
> -- 
> Best Regards,
> Artem Bityutskiy
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
