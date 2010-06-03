Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab0FCUKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:10:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924Ab0FCUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:10:32 -0400
Date: Thu, 3 Jun 2010 13:05:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Daniel Walker <dwalker@codeaurora.org>
cc: Russell King <rmk@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
In-Reply-To: <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
Message-ID: <alpine.LFD.2.00.1006031258350.8175@i5.linux-foundation.org>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>  <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>  <20100603181010.GA25779@flint.arm.linux.org.uk>  <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org> 
 <20100603185333.GD25779@flint.arm.linux.org.uk>  <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org> <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Daniel Walker wrote:
> 
> If you did this for drivers, what about disabling a driver? If we used
> "select" wouldn't that force all the drivers on without allowing it to
> be unselected?

Isn't that the point? If you have a specific platform, you don't want to 
pick them, you want to get the particular config file for it as a starting 
point. That's the _only_ reason to have those insane 177 defconfig files - 
because you want a _particular_ one.

Once you have a particular one, you can always edit it with the regular 
configuration tools - including making tweaks by hand - as much as you 
want.

So the only point of the thing would always be to get a result config 
file, one that you can then edit to your hearts content. And get it from a 
human-readable and writable description file, so that it would make sense 
to check it in to the kernel repository.

Because right now, the current defconfig files DO NOT MAKE SENSE in the 
kernel repository. They are useless crud, and they hurt.

So what I do _not_ want is the current crazy "give people these totally 
unreadable and unwritable raw config files". I want that extra step in 
between: something that allows you to _generate_ those idiotic files, but 
generate them from a reasonable human-editable template.

And a Kconfig.xyz file _could_ be such a template. 

But anyway, I'm not actually all that excited about playing games with 
Kconfig files either. And I simply don't care. To me, a "git rm 
*defconfig" is perfectly acceptable. If you want to keep the current 
defconfig files, you can keep them on some random ARM site ("Here's a 
defconfig file for Nexus One").

So I'm actually perfectly fine with "no defconfig files at all, not even a 
template that can generate them". You can get the files from somewhere 
else where they don't hurt the kernel.

			Linus
