Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965868Ab2FBVUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 17:20:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965785Ab2FBVT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 17:19:58 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20120601210451.GC4258@opensource.wolfsonmicro.com>
References: <1337691917-15040-2-git-send-email-ldewangan@nvidia.com>
	<4FBBC192.7030900@wwwdotorg.org>
	<4FBBC830.2060802@nvidia.com>
	<4FBBCA8F.3050903@wwwdotorg.org>
	<4FBBD33C.8020802@nvidia.com>
	<4FBBDA97.6000006@wwwdotorg.org>
	<4FBBDE06.5080806@nvidia.com>
	<4FC916AC.4060804@wwwdotorg.org>
	<20120601204052.GB4258@opensource.wolfsonmicro.com>
	<4FC92990.5030104@wwwdotorg.org>
	<20120601210451.GC4258@opensource.wolfsonmicro.com>
Date: Sat, 2 Jun 2012 14:19:57 -0700
Message-ID: <CAOesGMgYAR938F8PnVWaymzMBQwDKeAiUgEP81bv2nN14NmLGg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator tps65911
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+devicetree-discuss and grant/rob]

On Fri, Jun 1, 2012 at 2:04 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Jun 01, 2012 at 02:44:00PM -0600, Stephen Warren wrote:
>
>> Could you expand on "named property" a bit; I'm not quite sure what
>> you're getting at - literally a property with name "named" (which
>> would be the same as regulator-id under just a different property
>> name), or ...?
>
> Just a property where we only care about a name (ie, that the property
> is present).
>
>> > Can't we use the right hand side of this?  It appears to just be
>> > syntactic sugar without any current meaning.
>
>> The stuff to the right of @ is the "unit address" and must match the
>> value in the reg property. Using that was the first proposal I had
>> above (which I also didn't like as much)
>
> The stuff to the left of the @ is just noise right now, though - it has
> no meaning currently.  It's filled in with "regulator" because we need
> to put something there AFAICT.

Right. In general (and historically) in the device tree, names of the
nodes should have meaning for the person reading the device tree, but
it's not meant to be used for software to figure out the hardware
configuration -- that should instead be handled through compatible +
other properties.

Names are generally kept fairly generic (ethernet, cpus, memory, pci, etc).

Where it starts to become gray area is when it comes down to specific
bindings, and essentially the device nodes underneath of those
devices. It's been generally accepted that we can put meaning to the
names there if needed, but it's still better to avoid it.

I was originally OK with the regulator binding where names have
meaning, but after having looked at it a bit recently when looking at
bindings for some new boards we have, I realized that the original
suggestion for regulator bindings doesn't necessarily isolate the
naming dependencies to only be under the regulators in question. In
particular, for things such as fixed regulators, they can be located
at other places in the device tree.

Maybe the solution to that case is to just aggregate them in one place
and make a pseudo-binding for that (or those, in case of multiple
locations).

On the rest of the name-has-meaning discussion, I think it would be
cleaner to move away from it now while there's relatively few users of
it (with a migratin path), rather than revise it later. But I'll leave
it to Grant and Rob to decide which way the prefer things to be. I
think they might both be travelling around LC/LinuxCon events at the
moment though.


-Olof
