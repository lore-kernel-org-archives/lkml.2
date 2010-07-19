Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab0GSFVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 01:21:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41639 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab0GSFVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 01:21:18 -0400
MIME-Version: 1.0
In-Reply-To: <20100716234918.GA31060@shareable.org>
References: <20100713230352.6781.18644.stgit@angua> <1279062881.4609.34.camel@c-dwalke-linux.qualcomm.com> 
	<AANLkTin69tN3NQHD2wvkA0G-lj3f9tSZEnhzdyJdTh9m@mail.gmail.com> 
	<1279064008.4609.48.camel@c-dwalke-linux.qualcomm.com> <alpine.LFD.2.00.1007131941140.10598@xanadu.home> 
	<1279124563.21162.14.camel@c-dwalke-linux.qualcomm.com> <20100716234918.GA31060@shareable.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 18 Jul 2010 23:20:57 -0600
X-Google-Sender-Auth: tYMHTCxQfW4SjeLEh0HlS8f0mKo
Message-ID: <AANLkTilqZKk_tzGTLqhD7bNVGX_avXwy7_fXvoR96qNL@mail.gmail.com>
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for 
	defconfig
To: Jamie Lokier <jamie@shareable.org>
Cc: Daniel Walker <dwalker@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        linux-kbuild@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 5:49 PM, Jamie Lokier <jamie@shareable.org> wrote:
> Daniel Walker wrote:
>> > But all the rest is arbitrary and could be part of common shared
>> > profiles or the like in defconfig format.
>>
>> I'm sure most people will want to have a config isolated to their
>> specific device. That to me seems reasonable because everyone wants the
>> smallest possible kernel they can get for their given device.

Just to be clear (specifically for me as a maintainer) the purpose of
defconfigs is not to provide the best optimized kernel configuration
for each given board.  defconfigs are useful as a reasonable working
starting point, and to provide build coverage testing.

> Indeed, but people who want the smallest possible kernel for their
> specific device _in a particular use context_ tend to want:
>
>  - To disable support for parts of the device they aren't using.
>    For example, an SoC with integrated ethernet that isn't actually
>    wired up on their board, or where they're using an external ethernet
>    chip instead for some reason.
>
>  - To choose what's modular and what isn't, even for integrated
>    parts.  For example to control the bootup sequence, they might
>    want to delay integrated USB and IDE initialisation, which is done by
>    making those modular and loading them after bringing up a splash
>    screen earlier in the boot scripts.
>
> So there is still a need to be able to override the drivers and
> settings, but it's still incredibly useful to have defaults which
> describe the SoC or board accurately.

Yes.  The defconfig is only a starting point.  Maintaining the actual
config for the shipped kernel is the job of the distribution vendor
and I have zero interest in maintaining those configurations in the
kernel tree.

g.
