Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab2ENUtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:49:21 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:60592 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab2ENUtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:49:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120514123034.GD10453@n2100.arm.linux.org.uk>
References: <20120514105424.8596.38355.sendpatchset@w520>
	<20120514105451.8596.92367.sendpatchset@w520>
	<20120514123034.GD10453@n2100.arm.linux.org.uk>
Date: Tue, 15 May 2012 05:49:18 +0900
Message-ID: <CANqRtoTYWGhto7Zf=C=WHrT5fjc1p=6GE0cnozYLUuqbz=+LhA@mail.gmail.com>
Subject: Re: [PATCH 03/03] ARM: Undelete KZM9D mach-type
From: Magnus Damm <magnus.damm@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, horms@verge.net.au,
        olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 9:30 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, May 14, 2012 at 07:54:51PM +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> Undelete the KZM9D mach-type to allow build of board
>> for EMEV2 SoC support.
>
> If you've converted to use DT for KZM9D, do you still need this?

Good question. I guess it depends on how we want to make use of DT on
that piece of hardware. I do intend to convert the KZM9D board (not to
be mistaken for KZM9G!) to DT (and drop the generic EMEV2 SoC DT
unless someone really wants it at this timing), but I'm still not sure
if the SMP code in V2 is the way we want to do it. I suspect that
there is no way to support SMP without static entity mappings, so
perhaps I should rework that part and redo a V3? Or perhaps I should
interpret the EMEV2 silence as a good thing. =)

Unfortunately the KZM9D board only takes uImages, but good news is
that it actually feeds us the correct mach-type. This seems to be a
pretty common thing around here these days. I'm trying to get people
to actually store the DTB in the boot loader and pass it along, but
that seems rather far away at this point.

So with our current boot loader situation in mind I've been thinking
about adjusting the code in arch/arm/boot/compressed/head-shmobile.S
to check for the mach-type id and pass on a compiled-in DTB depending
on board type. This to allow us to build an uImage as usual and also
support multiple boards with a single kernel.

As you understand, the above plan will still make use of the mach-type
even now when we make more heavy use of DT. It seems like a rather
straightforward way to remain backwards compatible and still do DT,
but I'm not sure if such a solution would be acceptable by you, Arnd
and Olof. My plan right now is to try to cook up some code for the
above and see what feedback I get.

So yes, I'd like to make use of that mach-type entry unless there are
any objections.

Thanks for your help!

/ magnus
