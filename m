Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613Ab0EUPpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:45:04 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:49613 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933588Ab0EUPpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:45:00 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 May 2010 11:45:00 EDT
Date: Fri, 21 May 2010 16:34:54 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ralf Baechle <ralf@linux-mips.org>
cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-mips@linux-mips.org, Paul Mundt <lethal@linux-sh.org>,
       linux-sh@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: Re: bkl: Pushdowns for sound/oss ?
In-Reply-To: <20100521144055.GB13174@linux-mips.org>
Message-ID: <alpine.LFD.2.00.1005211613200.4344@eddie.linux-mips.org>
References: <alpine.LFD.2.00.1005211536330.25348@localhost.localdomain> <20100521144055.GB13174@linux-mips.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010, Ralf Baechle wrote:

> > particular in:
> > sound/oss/swarm_cs4297a.c
> 
> This one is specific to the Swarm, a MIPS-based platform indeed; I'll cc
> Maciej Rozycki who most likely is the only person on the planet knowing the
> technical details.  I don't even recall touching that file so my (C)
> header in there is a surprise :)

 You probably added a missing header inclusion or suchlike. ;)

 That's a Crystal Sound CS4297A AC'97 codec wired to a synchronous serial 
interface of the SWARM board.  It used to work with 2.4 after some tweaks 
I did back then (it broke in the little-endian mode or something like 
that), but I can't say anything about 2.6.  I think the driver should be 
dropped and the serial port in the sound mode (there's a demux to switch 
the interface's external connection between the codec and a DE-9 
connector; the serial port supports asynchronous mode as well) properly 
abstracted as a "sound card".

 There's a separate CS4297A driver already in our tree, so it should be 
used in place of the codec bits from this driver (which I believe were 
simply copied over at some point).  The rest is glue logic to set up 
serial line parameters correctly for the codec and switch the demux to the 
codec (no proper resource management is done for that though; the 
selection used to be made at the kernel build time).  This glue logic is 
all that's needed to be carried over to the new "sound card" driver.

 I have plans to do so in some indefinite future, probably when I retire 
and my grandchildren have grown up; anyone please feel free to take it 
first. ;)

  Maciej
