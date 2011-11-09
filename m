Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1KIMNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:13:45 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:39694 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab1KIMNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:13:42 -0500
X-SpamScore: -16
X-BigFish: VPS-16(zz9371K542M1432N98dKzz1202hzzz32i2a8h668h839h8e2h8e3h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
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
Thread-Index: AQHMnrhoEQrJGbTaskuNYjZspcYvt5Wkcnmg
Date: Wed, 9 Nov 2011 12:13:14 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CED1F9BF3F4@KCHJEXMB02.kpit.com>
References: <1320826417.1160.8.camel@L-0761.kpit.com>
 <20111109082005.GH23337@legolas.emea.dhcp.ti.com>
In-Reply-To: <20111109082005.GH23337@legolas.emea.dhcp.ti.com>
Accept-Language: en-US
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id pA9CDwxC026431


> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Wednesday, November 09, 2011 1:50 PM
> To: Ashish Jangam
> Cc: linaro-dev@lists.linaro.org; linux-kernel@vger.kernel.org;
> arnd@arndb.de; eric.miao@linaro.org; Mark Brown
> Subject: Re: Adding USB charge current property in the Linux Battery core
> 
> Hi,
> 
> On Wed, Nov 09, 2011 at 01:43:37PM +0530, ashishj3 wrote:
> > For a better performance in USB charging operation, the DA9052/53
> charging
> > current can be configured in accordance with the USB host current
> > delivering capacity (known through USB drivers negotiation).
> >
> > To implement this useful feature, a new writable property "USB charge
> current"
> > needs to be added in the Linux battery core.
> >
> > Let me know your views on it.
> 
> that's the wrong way to do it. What we need is to use the transceiver
> notifications to notify every time someone calls usb_gadget_vbus_draw()
> and pass the mA parameter as argument to the event notification.
> 

This means that we need to modify the function usb_gadget_vbus_draw()
to add a call like blocking_notifier_call_chain() but will this be fine with
the usb gadget driver maintainers?

> Charger driver should 'subscribe' to transceiver notifications and
> use the mA argument to reconfigure charging.
> 
> --
> balbi


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
