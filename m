Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab0JYHDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 03:03:24 -0400
Received: from mail.karo-electronics.de ([213.146.116.110]:60421 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab0JYHDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 03:03:23 -0400
Message-ID: <19653.11169.583189.236012@ipc1.ka-ro>
Date: Mon, 25 Oct 2010 09:02:57 +0200
From: =?iso-8859-15?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
To: Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Nguyen Dinh-R00091 <R00091@freescale.com>, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        valentin.longchamp@epfl.ch, daniel@caiaq.de, bryan.wu@canonical.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv5 2/3] ARM: imx: Add gpio-keys to plat-mxc
In-Reply-To: <20101024192053.GB25810@pengutronix.de>
References: <1287766575-4092-1-git-send-email-Dinh.Nguyen@freescale.com>
	<1287766575-4092-2-git-send-email-Dinh.Nguyen@freescale.com>
	<20101022182812.GA8554@pengutronix.de>
	<86A0E76937111F4C92FABEC0A2098851051D6090@az33exm21>
	<20101022194215.GB8554@pengutronix.de>
	<86A0E76937111F4C92FABEC0A2098851051D6116@az33exm21>
	<19651.61503.118511.923142@ipc1.ka-ro>
	<20101024192053.GB25810@pengutronix.de>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

Uwe Kleine-König writes:
> Hi Lothar,
> 
> On Sun, Oct 24, 2010 at 10:37:19AM +0200, Lothar Waßmann wrote:
> > Hi,
> > > >> How do you suggest I define this pin for Babbage board only? Do I add to iomux-mx51.h
> > > >> #define MX51_BABBAGE_PAD_EIM_A27__GPIO_2_21             IOMUX_PAD(0x45c, 0x0c8, 1, 0x0,
> > > >0,MX51_GPIO_PAD_CTRL | PAD_CTL_PUS_100K_UP) ?
> > > >>
> > > >> Or do I define the pin in the board file with a 100K_UP? Like how eukrea_mbimxsd-baseboard.c did for
> > > >MBIMXSD_GPIO_3_31?
> > > >I'd suggest something local to your machine file.  Unfortunately I don't
> > > >see an easy way to reuse the generic MX51_PAD_EIM_A27__GPIO_2_21 to
> > > >define your local symbol.  So I think something like you wrote above
> > > >should be fine.
> > > >
> > > >Too bad that
> > > >
> > > >	#define MX51_BABBAGE_PAD_EIM_A27__GPIO_2_21 (MX51_PAD_EIM_A27__GPIO_2_21 | PAD_CTL_PUS_100K_UP)
> > > >
> > > >doesn't work.
> > > 
> > > Yes, I also wish I didn't have to redefine the pin just because of PAD setting change. I am going to send out another patch that basically sets the pad_desc.pad_ctrl=PAD_SETTING in mxc_init_board() function. I think it's a bit cleaner than having to redefine the pin.
> > > 
> > IMO the 'struct pad_desc' should be replaced with an u64 bitmap that
> > would allow for the pullup and other definitions that may be board
> > specific to be simply or'ed to the pad definition.
> > 
> > I could try to provide a patch if this is agreed on.
> Hmm, I thought about that, too, when writing my mail and when I added
> the needed space for a struct pad_desc I stopped when it became >64.
> Somehow I must have got it wrong.  After rechecking now it's ==64, so
> yes, I'd like it.
> 
What kernel version should I base it on?
The master branch of git://git.pengutronix.de/git/imx/linux-2.6.git?


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
