Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2JWKX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:23:28 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:36556 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab2JWKX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:23:26 -0400
Date: Tue, 23 Oct 2012 12:23:12 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: balbi@ti.com
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Sourav Poddar <sourav.poddar@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121023122312.56b23e1c@skate>
In-Reply-To: <20121023100333.GA24418@arwen.pp.htv.fi>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
	<20121022155028.GA13791@core.coreip.homeip.net>
	<CACRpkdaQ1WfRWrx=RXMVkeFtwdERJsOpVa3DaXBTU2KZdgqhRQ@mail.gmail.com>
	<508664CA.7000601@ti.com>
	<CACRpkdbhCS-Vb0DtbTZQ_Zw_8SOh3Bqutme3Y2-QrxNqvMiNNw@mail.gmail.com>
	<20121023100333.GA24418@arwen.pp.htv.fi>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 23 Oct 2012 13:03:33 +0300, Felipe Balbi wrote:

> > But it appears that shmobile prefer to get all resources using
> > bus notifiers.
> > 
> > So we need to form some kind of consensus ... or live with
> > the fact that different systems do it different ways. Which will
> > explode the day we need to use a driver on two systems,
> > each using the other approach :-)
> 
> I much prefer having drivers explicitly manage all their resources,
> which would mean that pinctrl calls need to be done on probe() and, if
> necessary, during suspend()/resume().
> 
> Using bus notifiers for that is quite a hack IMHO.

Agreed. Just like drivers do their ioremap, request_irq and others,
they should also request their pin resources using the pinctrl API.
Hiding this behind a bus notifier is not nice.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
