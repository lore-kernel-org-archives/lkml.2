Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab0FCBYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 21:24:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932756Ab0FCBYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 21:24:34 -0400
Date: Wed, 2 Jun 2010 18:20:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kevin Hilman <khilman@deeprootsystems.com>
cc: Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org
Subject: Re: [GIT PULL] ARM MSM updates for 2.6.35-rc1
In-Reply-To: <87d3w9582z.fsf@deeprootsystems.com>
Message-ID: <alpine.LFD.2.00.1006021803350.8175@i5.linux-foundation.org>
References: <1274997173.10998.21.camel@c-dwalke-linux.qualcomm.com> <1275511857.27006.6.camel@c-dwalke-linux.qualcomm.com> <alpine.LFD.2.00.1006021413100.8175@i5.linux-foundation.org> <87d3w9582z.fsf@deeprootsystems.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jun 2010, Kevin Hilman wrote:
>
> There indeed has been lots of change in mach-davinci, but I wouldn't
> consider it noise.  In that one mach directory, I support ~10 SoCs in
> the same family and for each SoC there is at least one board
> supported.  I'm also a core developer for mach-omap*, and the number
> of SoCs/boards supported there is equally large.

The problem with this is that it's just not maintainable to keep on adding 
random stuff, especially since I doubt any of it ever gets aged away 
either.

arch/arm as-is is already about 800k lines. Compare that to arch/x86, 
which is less than a third of that. Now, what is the difference?

 - x86 has its drivers elsewhere, and they are _discoverable_ and not 
   hardcoded to some platform. They have often also been useful (to say 
   the least) to other architecture platforms. That's not always true for 
   all of them (we do have drivers/platform/x86, but at least that's 
   maintained separately and is nowhere near the mess that is ARM)

 - in contrast, ARM seems to be a mess. I realize it's largely because the 
   hardware companies are so f*cked up, but guys, we need to have some 
   handle on it too.  I was willing to take the direct merges, and I still 
   am, but I'm willing to do it only if I have a feeling that things are 
   under control. And I'm not getting that feeling.

 - TWO HUNDRED THOUSAND lines of arch/arm is just pure garbage, namely the 
   defconfig files. Quite frankly, anybody who calls that anything but 
   pure "noise" is just misguided and being stupid.

So yes, I do consider a lot of it "noise". When there's two hundred 
thousand lines of garbage, and it keeps growing without bounds, something 
needs to be done. 

Now, I'm actually considering just getting rid of all the 'defconfig' 
files entirely. The x86 model is sane (there's two of them, nobody likely 
uses them), but ARM and POWERPC (and to a lesser config SH and MIPS) have 
turned the whole concept into a disgusting mess. 

But while POWERPC has abused that thing too, in _other_ respects it has 
been much less egregious. 

So I can largely fix the defconfig mess on my own (by just using a simple 
oneliner shell script to deletes them all) but that really only fixes one 
particularly annoying symptom - not the underlying issue. We do need 
somebody to maintain the arm platform mess, and actually tries to get some 
infrastructure or something in place so that it doesn't explode.

> The fact is that ARM-based devices multiply like rabbits, and there is
> a huge amount of diversity between the various derivatives.  Also,
> support most of these devices has lived out of tree for a long time.
> Now that we have a relatively direct path which doesn't require any
> single person to have to understand all the mind-numbing details of
> all of these ARM-based platforms, it has allowed us to significantly
> improve the support for these devices upstream.  Anything that is
> common to all devices still goes through RMK.

The thing is, I bet there is way more commonality still to be taken 
advantage of.  And even if there isn't, we need somebody who cares, and 
doesn't just mindlessly aggregate all the crud. Somebody with the taste to 
say "ok, that's just too effin ugly, you need to fix things up" 
occasionally.

		Linus
