Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2IQIpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:45:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43184 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab2IQIpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:45:17 -0400
MIME-Version: 1.0
In-Reply-To: <50559737.8000705@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347550912-18021-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347550912-18021-4-git-send-email-sebastian.hesselbarth@gmail.com>
	<20120916074652.GM28177@lunn.ch>
	<50559737.8000705@gmail.com>
Date: Mon, 17 Sep 2012 10:45:15 +0200
Message-ID: <CACRpkdY-Nyn73EJLvE1RsL4hgMRm6hALtnS-eKAXU7edot2V9A@mail.gmail.com>
Subject: Re: [PATCH v4 03/10] pinctrl: mvebu: kirkwood pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 11:09 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> On 09/16/2012 09:46 AM, Andrew Lunn wrote:

>> Here you are suggesting we have to put into the DT what chip we expect
>> to be on.
>>
>> What is the advantage of this, over getting the information from the
>> device itself?
>
> If there are no objections from the others, I agree to determine the
> variant from the existing kirkwood_id(). I was just unsure if it is
> ok to use platform-specific code with DT here.
>
> Any ideas how to get kirkwood_id() linked into pinctrl-kirkwood with
> the get-rid-of-arch-includes policy?

You found the weak spot between two consolidation tracks.

Getting rid of a broadcast autodetect functions from say
<mach/foo-id-probe.h> is nominally done by passing the data
to the driver as platform data instead, and only using
these functions in the mach-foo folder when populating
platform data, and thus it can be made into a local
header, say mach-foo/foo-id-probe.h

So the machine/arch code reads these registers to
populate the platform data and device drivers only
look at the platform data, which has some enum or
bool indicating what hardware it's running on, cool.

But according to the other consolidation track, platform
data should go into device tree bindings.

So the conclusion is that the DT must contain the data
about the platform, so it's not auto-probed by the kernel.
(I.e. the kernel reads no registers to figure out what hardware
this is, that stuff comes from the device tree.)

DT purists will say that the boot loader should ask the chipset
what it is with the same register writes and populate the
DT accordingly, instead of loading a precompiled blob.
Some may even ponder the crazy concept of amending the
DT in the kernel at early boot.

But in practice someone will give up, encode the stuff in
the static device tree and autoprobing of the platform
goes out the window.

Yours,
Linus Walleij
