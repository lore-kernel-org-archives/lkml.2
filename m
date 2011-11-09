Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1KIMaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:30:30 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:47020
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353Ab1KIMa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:30:28 -0500
X-SpamScore: -16
X-BigFish: VPS-16(zz9371K542M1432N98dKzz1202hzz8275chz32i2a8h668h839h8e2h8e3h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:220.225.38.51;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "eric.miao@linaro.org" <eric.miao@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "david-b@pacbell.net" <david-b@pacbell.net>
Subject: RE: Adding USB charge current property in the Linux Battery core
Thread-Topic: Adding USB charge current property in the Linux Battery core
Thread-Index: AQHMntnoBnCWHyb5kE247yhag0WwPJWkeC9A
Date: Wed, 9 Nov 2011 12:30:19 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CED1F9BF409@KCHJEXMB02.kpit.com>
References: <1320826417.1160.8.camel@L-0761.kpit.com>
 <20111109082005.GH23337@legolas.emea.dhcp.ti.com>
 <C3AE124F08223B42BC95AEB82F0F6CED1F9BF3F4@KCHJEXMB02.kpit.com>
 <20111109121950.GB16315@legolas.emea.dhcp.ti.com>
In-Reply-To: <20111109121950.GB16315@legolas.emea.dhcp.ti.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.10.38.22]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pA9CUeo3026524

> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Wednesday, November 09, 2011 5:50 PM
> To: Ashish Jangam
> Cc: balbi@ti.com; linaro-dev@lists.linaro.org; linux-
> kernel@vger.kernel.org; arnd@arndb.de; eric.miao@linaro.org; Mark Brown;
> david-b@pacbell.net
> Subject: Re: Adding USB charge current property in the Linux Battery core
> 
> On Wed, Nov 09, 2011 at 12:13:14PM +0000, Ashish Jangam wrote:
> >
> > > -----Original Message-----
> > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > Sent: Wednesday, November 09, 2011 1:50 PM
> > > To: Ashish Jangam
> > > Cc: linaro-dev@lists.linaro.org; linux-kernel@vger.kernel.org;
> > > arnd@arndb.de; eric.miao@linaro.org; Mark Brown
> > > Subject: Re: Adding USB charge current property in the Linux Battery
> core
> > >
> > > Hi,
> > >
> > > On Wed, Nov 09, 2011 at 01:43:37PM +0530, ashishj3 wrote:
> > > > For a better performance in USB charging operation, the DA9052/53
> > > charging
> > > > current can be configured in accordance with the USB host current
> > > > delivering capacity (known through USB drivers negotiation).
> > > >
> > > > To implement this useful feature, a new writable property "USB charge
> > > current"
> > > > needs to be added in the Linux battery core.
> > > >
> > > > Let me know your views on it.
> > >
> > > that's the wrong way to do it. What we need is to use the transceiver
> > > notifications to notify every time someone calls usb_gadget_vbus_draw()
> > > and pass the mA parameter as argument to the event notification.
> > >
> >
> > This means that we need to modify the function usb_gadget_vbus_draw()
> > to add a call like blocking_notifier_call_chain() but will this be fine
> with
> > the usb gadget driver maintainers?
> 
> I am the USB gadget driver maintainer and I have plans to do that
> myself. First thing we need to do is convert the final UDC drivers to
> the udc Class which I wrote and Sebastian helped brushing it up, then we
> uninline the usb_gadget_* wrappers and move them to
> drivers/usb/gadget/udc-core.c, then we can move the transceiver notifier
> to the UDC as it makes more sense, and convert blocking into atomic
> notifier.

This sounds good but since most PMICs have I2C bus connectivity using atomic
notifier can introduce problems. 
> 
> After that we can add notifications to all gadget events/API/etc...
> 
> --
> balbi


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
