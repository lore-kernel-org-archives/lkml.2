Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab2IUK4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 06:56:13 -0400
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:32999 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab2IUK4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:56:09 -0400
Message-ID: <505C47C6.3070907@codethink.co.uk>
Date: Fri, 21 Sep 2012 11:56:06 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lior Amsalem <alior@marvell.com>, Rob Landley <rob@landley.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v4 03/10] pinctrl: mvebu: kirkwood pinctrl driver
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com> <50559737.8000705@gmail.com> <CACRpkdY-Nyn73EJLvE1RsL4hgMRm6hALtnS-eKAXU7edot2V9A@mail.gmail.com> <201209201530.40974.arnd@arndb.de> <CACRpkdZYr2B83e3mBmMkO8Ai3xU_QGevfbSOSNoTvK3Lz6y6mg@mail.gmail.com> <20120920213636.2ee27d41@skate>
In-Reply-To: <20120920213636.2ee27d41@skate>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/09/12 20:36, Thomas Petazzoni wrote:
> Dear Linus Walleij,
>
> On Thu, 20 Sep 2012 21:28:20 +0200, Linus Walleij wrote:
>
>> So what I'm after is whether in this case statically encoding this
>> onto the .dtsi files is the right thing to do, or whether the boot loader
>> or kernel should runtime-modify the device tree, patching in
>> the ASIC-specific info, just like device tree files can override
>> properties from include files.
>>
>> Or if this is a bad idea.
>>
>> Nobody is doing that right now AFAICT, but it is surely possible....
>
> If I understand correctly, we would like drivers to be able to read
> some common "system" registers to figure out which SoC variant we are
> running on. Such feature should normally be provided by code in
> arch/arm/mach-*/ and called by drivers, but we are trying to eliminate
> all dependencies of driver code on architecture code, correct?
>
> So, wouldn't we need a small, architecture-independent, infrastructure,
> through which architecture-specific code could "register" at boot
> time which SoC we are running on, and drivers could query this
> information from the common infrastructure?
>
> Of course, the major problem is to figure out what is the good
> representation for this SoC identifier. Do we need a big list of SoCs
> like we had machine IDs? A simple string? Or maybe there is just no
> good way, and the whole idea is moot.

I think this is a bad idea, it means you can't try and re-use an
older kernel on an newer SoC design which may be broadly compatible
without changing the kernel source to add these flag checks.

I also don't like information hidden away that the user cannot see.
Having the device specifically named allows us to see from sysfs
exactly what we are dealing with.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
