Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab0FBX1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:27:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33333 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758204Ab0FBX1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:27:19 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org
Subject: Re: [GIT PULL] ARM MSM updates for 2.6.35-rc1
References: <1274997173.10998.21.camel@c-dwalke-linux.qualcomm.com>
	<1275511857.27006.6.camel@c-dwalke-linux.qualcomm.com>
	<alpine.LFD.2.00.1006021413100.8175@i5.linux-foundation.org>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Wed, 02 Jun 2010 16:27:16 -0700
In-Reply-To: <alpine.LFD.2.00.1006021413100.8175@i5.linux-foundation.org> (Linus Torvalds's message of "Wed\, 2 Jun 2010 14\:27\:06 -0700 \(PDT\)")
Message-ID: <87d3w9582z.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, 2 Jun 2010, Daniel Walker wrote:
>> 
>> Don't forget about this one! Or was something wrong with it?
>
> I got a bit frustrated with ten different ARM pulls per day at one point.
>
> There's something wrong with ARM development. The amount of pure noise in 
> the patches is incredibly annoying. Right now, ARM is already (despite me 
> not reacting to some of the flood) 55% of all arch/ changes since 2.6.34, 
> and it's all pointless churn in 
>
> 	arch/arm/configs/
> 	arch/arm/mach-xyz
> 	arch/arm/plat-blah
>
> and at a certain point in the merge window I simply could not find it in 
> me to care about it any more.
>
> Do you guys at all talk about this problem? Have any of the ARM people 
> bothered to look at the arch/arm diffs and see how mind-deadening they 
> are? I try to look through these kinds of things when I pull, but after a 
> million lines of pure noise, it gets old pretty quickly.
>
> Somehow, I can't believe that you need thousands of lines for each random 
> arch/arm/mach-xyz (yeah, some very few of them are smaller).

As one of the sub-arch maintainers (arch/arm/mach-davinci), I can
attempt to answer for some of the churn.

There indeed has been lots of change in mach-davinci, but I wouldn't
consider it noise.  In that one mach directory, I support ~10 SoCs in
the same family and for each SoC there is at least one board
supported.  I'm also a core developer for mach-omap*, and the number
of SoCs/boards supported there is equally large.

Each time we add support for a new SoC in the family some changes are
needed to generalize existing code to work on the existing SoCs as
well as the new ones.  This generalizing is actually reducing the size
of the diff compared to what it would be if it were added using
copy-paste, but I understand why it might look like churn.

I certainly understand why this would be mind-numbing to anyone who
doesn't care about davinci, or ARM-based devices.  Indeed, even other
ARM sub-arches developers don't need to care about most of what is in
my mach dir and would consider it mind-numbing as well.

The fact is that ARM-based devices multiply like rabbits, and there is
a huge amount of diversity between the various derivatives.  Also,
support most of these devices has lived out of tree for a long time.
Now that we have a relatively direct path which doesn't require any
single person to have to understand all the mind-numbing details of
all of these ARM-based platforms, it has allowed us to significantly
improve the support for these devices upstream.  Anything that is
common to all devices still goes through RMK.

Kevin
