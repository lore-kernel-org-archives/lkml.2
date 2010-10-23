Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab0JWCm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 22:42:57 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:16150 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab0JWCm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 22:42:56 -0400
X-SpamScore: -31
X-BigFish: VS-31(zz542N1432N98dN4015L9371P10d1Izz1202hzz8275bhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCHv5 2/3] ARM: imx: Add gpio-keys to plat-mxc
Date: Fri, 22 Oct 2010 19:43:00 -0700
Message-ID: <86A0E76937111F4C92FABEC0A2098851051D6116@az33exm21>
In-Reply-To: <20101022194215.GB8554@pengutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv5 2/3] ARM: imx: Add gpio-keys to plat-mxc
Thread-Index: ActyIU1/15s9HAIsThGZwQMrI6xgggAOi7NQ
References: <1287766575-4092-1-git-send-email-Dinh.Nguyen@freescale.com> <1287766575-4092-2-git-send-email-Dinh.Nguyen@freescale.com> <20101022182812.GA8554@pengutronix.de> <86A0E76937111F4C92FABEC0A2098851051D6090@az33exm21> <20101022194215.GB8554@pengutronix.de>
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <s.hauer@pengutronix.de>,
        <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
        <grant.likely@secretlab.ca>, <bryan.wu@canonical.com>,
        <amit.kucheria@canonical.com>
X-Reverse-DNS: az33egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Uwe,

>-----Original Message-----
>From: Uwe Kleine-König [mailto:u.kleine-koenig@pengutronix.de]
>Sent: Friday, October 22, 2010 2:42 PM
>To: Nguyen Dinh-R00091
>Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux@arm.linux.org.uk;
>s.hauer@pengutronix.de; valentin.longchamp@epfl.ch; daniel@caiaq.de; grant.likely@secretlab.ca;
>bryan.wu@canonical.com; amit.kucheria@canonical.com
>Subject: Re: [PATCHv5 2/3] ARM: imx: Add gpio-keys to plat-mxc
>
>Hello Dinh,
>
>On Fri, Oct 22, 2010 at 11:58:16AM -0700, Nguyen Dinh-R00091 wrote:
>> >-----Original Message-----
>> >From: Uwe Kleine-König [mailto:u.kleine-koenig@pengutronix.de]
>> >Sent: Friday, October 22, 2010 1:28 PM
>> >To: Nguyen Dinh-R00091
>> >Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux@arm.linux.org.uk;
>> >s.hauer@pengutronix.de; valentin.longchamp@epfl.ch; daniel@caiaq.de; grant.likely@secretlab.ca;
>> >bryan.wu@canonical.com; amit.kucheria@canonical.com
>> >Subject: Re: [PATCHv5 2/3] ARM: imx: Add gpio-keys to plat-mxc
>> >
>> >On Fri, Oct 22, 2010 at 11:56:14AM -0500, Dinh.Nguyen@freescale.com wrote:
>> >> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>> >>
>> >> Add imx_add_gpio_keys function to add gpio-keys in plat-mxc
>> >>
>> >> This patch is based on Sascha Hauer's imx/linux-2.6 for-rmk tree.
>> >(This information isn't interesting once the patch is in git, so it can
>> >better go after the tripple-dash below.)
>> >
>> >> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>> >Patch 1 depends on this one, so you should swap their order.
>> >
>> >> ---
>> >I share the concerns of Arnaud.  MX51_GPIO_PAD_CTRL looks OK,
>> >PAD_CTL_PUS_100K_UP does not.
>>
>> How do you suggest I define this pin for Babbage board only? Do I add to iomux-mx51.h
>> #define MX51_BABBAGE_PAD_EIM_A27__GPIO_2_21             IOMUX_PAD(0x45c, 0x0c8, 1, 0x0,
>0,MX51_GPIO_PAD_CTRL | PAD_CTL_PUS_100K_UP) ?
>>
>> Or do I define the pin in the board file with a 100K_UP? Like how eukrea_mbimxsd-baseboard.c did for
>MBIMXSD_GPIO_3_31?
>I'd suggest something local to your machine file.  Unfortunately I don't
>see an easy way to reuse the generic MX51_PAD_EIM_A27__GPIO_2_21 to
>define your local symbol.  So I think something like you wrote above
>should be fine.
>
>Too bad that
>
>	#define MX51_BABBAGE_PAD_EIM_A27__GPIO_2_21 (MX51_PAD_EIM_A27__GPIO_2_21 | PAD_CTL_PUS_100K_UP)
>
>doesn't work.

Yes, I also wish I didn't have to redefine the pin just because of PAD setting change. I am going to send out another patch that basically sets the pad_desc.pad_ctrl=PAD_SETTING in mxc_init_board() function. I think it's a bit cleaner than having to redefine the pin.

>Best regards
>Uwe
>
>--
>Pengutronix e.K.                           | Uwe Kleine-König            |
>Industrial Linux Solutions                 | http://www.pengutronix.de/  |

Thanks,
Dinh

