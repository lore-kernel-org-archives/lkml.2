Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab0FEOpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 10:45:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756532Ab0FEOpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 10:45:44 -0400
Date: Sat, 5 Jun 2010 07:39:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
cc: Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
       Daniel Walker <dwalker@codeaurora.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: ARM defconfig files
In-Reply-To: <AANLkTilSBWeYTV6YlLK4XdoBsSFSVvtJIRmJxAdNu92U@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006050734370.8175@i5.linux-foundation.org>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603181010.GA25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org> <20100603185333.GD25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org> <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com> <20100603194559.GF25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031305310.8175@i5.linux-foundation.org>
 <alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org> <20100603211707.GA6499@atomide.com> <AANLkTilSBWeYTV6YlLK4XdoBsSFSVvtJIRmJxAdNu92U@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 Jun 2010, Felipe Contreras wrote:
> 
> How about instead of using full defconfigs, we use minimal ones and
> let the rest be determined with defaults.

I wouldn't mind that either, but there needs to be some way to check that 
they _are_ minimal. Which is more complicated than even SAT, afaik. 

So the reason I don't like the "minimal defconfig" notion is that a 
"regular defconfig" will work equally well, and lazy people will thus not 
bother to make it minimal (because it's work) and instead just pick the 
full config output.

And we're all lazy. So gearing the process towards something that makes it 
easy for lazy cases to do the wrong thing is a bad thing.

We also don't have any way to "source" these config files from each other, 
so there's no way from within such a config file to say "use the basic 
omap3 defaults an then just add this on top". You can do it by 
concatenating several such files manually from the Makefile or whatever 
script, of course, but then you end up with the files themselves not 
actually describing what they do.

That's why I suggested the Kconfig format instead. It's the exact same 
idea, but it's a "before pre-processing" format that already supports 
including other files.

		Linus
