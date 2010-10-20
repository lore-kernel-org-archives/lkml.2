Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0JTAbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 20:31:23 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:52574 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab0JTAbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 20:31:21 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Q9c9ReJXH2aiBJuBHqkv7
Date: Tue, 19 Oct 2010 17:31:16 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Felipe Balbi <me@felipebalbi.com>, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
Message-ID: <20101020003115.GC30991@atomide.com>
References: <20101019103234.GI31170@legolas.emea.dhcp.ti.com>
 <AANLkTinXzMQXoyyu+anSCvSuE9w3FWAP5HswDS0kfpzE@mail.gmail.com>
 <20101019111613.GJ31170@legolas.emea.dhcp.ti.com>
 <AANLkTikkMphKa2DGGtWxy-3LpFX0kn92UEYPj==Euzok@mail.gmail.com>
 <20101019115236.GL31170@legolas.emea.dhcp.ti.com>
 <AANLkTim3NsgjC3Nh8VCCrx4cV1Y+kn38=30=en0KCft6@mail.gmail.com>
 <6ea089ac75d4d15d88698468eacb7fe3@secure211.sgcpanel.com>
 <AANLkTinYM5aavk9_jcTTymff=OY+Yyv8T6C+dmMih0p_@mail.gmail.com>
 <20101019234414.GB30991@atomide.com>
 <87fww1u3fw.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fww1u3fw.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@deeprootsystems.com> [101019 17:04]:
> Tony Lindgren <tony@atomide.com> writes:
> >
> > This actually produces a booting omap2+ kernel with no .config
> > at all. I've tested it with:
> >
> > $ echo CONFIG_ARCH_OMAP=y > .config
> > $ yes "" | ARCH=arm make oldconfig
> >
> > So if you have something that's needed on almost every omap,
> > you can select it there.
> 
> One thing I don't like about this is that there is currently no way to
> 'select' as a module.

I think that would take two passes to do currently for the depenencies..
But we can certainly select all the omap drivers as modules in
omap2plus_defconfig.

> In order to get to a minimal kernel, in theory, we don't need regulator,
> i2c, MFD, or twl4030* built in.  They should all be built as modules.
> Yes, there are some assumptions made today that some of these things are
> built in, and then are used from init code, but that is broken.

I think the only thing keeping us from doing that is that most of
the boards don't use initramfs. Without initramfs these are needed
to mount root on MMC.
 
> If someone is looking for a good omap-kernel-janitors project, I would
> suggest getting to a *really* minimal OMAP2+ kernel with everything
> possible built as modules to be a very good project.

Agreed. The way to do that is to set everything possible as modules
in omap2plus_defconfig, and move to kernel + initramfs based booting
like most distros do.

Regards,

Tony
