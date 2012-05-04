Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760514Ab2EDWny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:43:54 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45646 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760481Ab2EDWnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:43:53 -0400
Date: Fri, 4 May 2012 23:43:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Wookey <wookey@wookware.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linaro-dev@lists.linaro.org, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Tony Lindgren <tony@atomide.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Making ARM multiplatform kernels DT-only?
Message-ID: <20120504224318.GL897@n2100.arm.linux.org.uk>
References: <201205031350.35476.arnd@arndb.de> <CAK2p4sJj7FRVSStVkqmn16sUv8S3vHmUYCU_VzTWAWzqV5yVsg@mail.gmail.com> <20120504142057.GQ27023@stoneboat.aleph1.co.uk> <20120504143518.GF26481@n2100.arm.linux.org.uk> <CACRpkdZ3m=PXg35==3wo2xHPL7TRn1W0AX_CeMKjPd1U+pTAGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ3m=PXg35==3wo2xHPL7TRn1W0AX_CeMKjPd1U+pTAGQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 10:03:40PM +0200, Linus Walleij wrote:
> On Fri, May 4, 2012 at 4:35 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> 
> > Well, my understanding is that there's DT patches around for Versatile.
> 
> Is there? There is some in-tree stuff, but haven't seen any other
> sign of patches.
>[...]
> make it clear that noone ever tested an MMC card on a Versatile
> booted on real hardware using DT. And I strongly suspect there
> are more instances like that, it seems AACI, GPIO and I2C and
> I guess whatever you cannot test on QEMU is just unsupported.

Given that we've converted stuff like MMCI to use DT, it _should_ be
the case that we can just add the appropriate DT description to the
existing Versatile DT - we might need to create some new GPIO devices
for things like SYSMCI and get rid of the status function, or we
could just use the auxdata stuff in the mean time.

Either way, we've solved these problems on other platforms, and the
shared code has already been fixed or is being fixed for stuff like
Versatile Express.

Lets also not forget that the VIC code has already been converted to
DT.

So I don't think there's a big problem here - I think most of the
pieces of the jigsaw are in place through converting other platforms.
