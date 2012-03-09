Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab2CINpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:45:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab2CINo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:44:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: versatile: automatically pick a board in Kconfig
Date: Fri, 9 Mar 2012 13:44:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: mathieu.poirier@linaro.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca
References: <1331074162-18147-1-git-send-email-mathieu.poirier@linaro.org> <20120306231306.GE15201@n2100.arm.linux.org.uk>
In-Reply-To: <20120306231306.GE15201@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203091344.52883.arnd@arndb.de>
X-Provags-ID: V02:K0:AU0YCTt9+L8nedD3yu4mjkHeCOzGEwLTRB0opdRyZ4Y
 85YDZZeZdnB71Lr/DaXPoMLCaRZEBEAm8KTPI3ZJKLSY0HUZCi
 PsRfHmSp8AsRz7Z6UMqzZSOe9W8OdIJY63jmaXX8EfrRTLqCMT
 /2COXvJUWWYmk1QOqNVUlL14Iob3oGOXrlgCiMAhRFbxlHf4Bw
 uepSFa0LgRAFH7Vipz6c2cYB11NLJRzpLCMv4fx+LH3eFKpiw8
 MrhbqtlX+ZyCtX2tn117194RmSii/lJqjOgVEbZZ02XKunvEuD
 3S4ZtqT6M437o6x3BL5jgccvHikEkc/7W7IzUh/NDx4ZEY10Dp
 pDSKjtmaVDRU/KCsTHHo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2012, Russell King - ARM Linux wrote:
> On Tue, Mar 06, 2012 at 03:49:22PM -0700, mathieu.poirier@linaro.org wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > The versatile platform supports building any combination of the
> > three board types (AB, PB, DT), but at least one of them has
> > to be enabled. This adds the necessary Kconfig statement to
> > enforce that at least one of the three is selected.
> 
> This approach to 'fixing' the Kconfig doesn't scale particularly well
> when we've got lots of platforms to deal with.
> 
> I much prefer using KALLCONFIG= to seed allno/allyes/allmod/rand configs.
> If you want to target a particular SoC you have to do that anyway.  And
> you have to use that to ensure that you get a sane config state so that
> Kconfig doesn't try and ask for the PHYS_OFFSET value - it will decide
> to make that empty and then refuse to reprocess the Kconfig when you
> try to build the kernel.
> 
> So I don't think there's any point to adding stuff like this.

I don't like the this particular way of working around Kconfig too
much either, but I would really like to see it get resolved in a way
that lets randconfig pick an arbitrary set and still finish the
build. Two other ways to get there that I can see are:

* Add a "multichoice" keyword in Kconfig that lets you write a
list of which at one or more items can be enabled, but not all
disabled. This might be the cleanest solution but it will take
some time to get implemented and have everyone convinced that it's
actually a good idea.

* Remove the ASSERT() for missing machine types, and if possible turn
it into a warning instead. This one would be for you to decide.

I think hardcoding the combination of boards using KCONFIG_ALLCONFIG
is not ideal because that will not fail to catch a lot of real bugs
that I found for unexpected combinations of boards.

	Arnd
