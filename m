Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab0FCEbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:31:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777Ab0FCEa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:30:59 -0400
Date: Wed, 2 Jun 2010 21:26:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Ellerman <michael@ellerman.id.au>
cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org
Subject: Re: [GIT PULL] ARM MSM updates for 2.6.35-rc1
In-Reply-To: <1275536698.22020.81.camel@concordia>
Message-ID: <alpine.LFD.2.00.1006022112320.8175@i5.linux-foundation.org>
References: <1274997173.10998.21.camel@c-dwalke-linux.qualcomm.com>  <1275511857.27006.6.camel@c-dwalke-linux.qualcomm.com>  <alpine.LFD.2.00.1006021413100.8175@i5.linux-foundation.org>  <87d3w9582z.fsf@deeprootsystems.com>  <alpine.LFD.2.00.1006021803350.8175@i5.linux-foundation.org>
 <1275536698.22020.81.camel@concordia>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Michael Ellerman wrote:
> 
> You can sort of do that today, by just storing a delta, but oldconfig
> will silently turn off things you have enabled if prereqs change, so
> that doesn't really work I think.

I think you can do it today with various hacks. Up to and including 
basically doing something that just selects the options you want.

IOW, you could likely have a human-written Kconfig.<platform> file that 
just does 

	define_bool MYPLATFORM y
		select .. everything I need ..

	include Kconfig.main

or a number of other tricks.

Ingo and the x86 folks (who I really think have done a very good job, and 
there really aren't any crazy defconfig files there) have this "make 
randconfig" together with scripted requirements so that you can actually 
_boot_ the random config, just because the requirements make sure that the 
things needed for booting on the test setup are selected.

I forget exactly what the build setup there is (Ingo described it to me 
long time ago, but since I don't even want to have a build farm in my 
home, I didn't care much).

But we certainly _can_ do a better job than the 'defconfig' thing that was 
really never meant for the kind of use it sees in ARM/POWERPC/SH/MIPS, and 
that really isn't appropriate for any manual editing (so people just run 
"make oldconfig" with tweaking or something, and then use the newly 
generated file).

And I suspect that it really is best to just remove the existing defconfig 
files. People can see them in the history to pick up what the heck they 
did, but no way will any sane model ever look even _remotely_ like them, 
so they really aren't a useful basis for going forward.

But don't worry. It didn't happen this merge window, obviously.

		Linus
