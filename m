Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab0JAUAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:00:12 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:40429 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab0JAUAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:00:10 -0400
Date: Fri, 1 Oct 2010 21:00:08 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Huang Ying <ying.huang@intel.com>
cc: Don Zickus <dzickus@redhat.com>, huang ying <huang.ying.caritas@gmail.com>,
        Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
In-Reply-To: <1285822630.6944.69.camel@yhuang-dev>
Message-ID: <alpine.LFD.2.00.1010012027360.21189@eddie.linux-mips.org>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>         <1285549026-5008-6-git-send-email-ying.huang@intel.com>         <20100927100901.GC32222@erda.amd.com>         <AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com>        
 <20100927133816.GP13563@erda.amd.com> <20100927152014.GY26290@redhat.com>         <1285634172.20791.92.camel@yhuang-dev> <20100928153247.GL26290@redhat.com>         <AANLkTinmhTgVhPsmGLC8Z-9Kx3xRovWy=9+R_5B4u6Cx@mail.gmail.com>         <20100930043628.GE26290@redhat.com>
 <1285822630.6944.69.camel@yhuang-dev>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010, Huang Ying wrote:

> > Is port 0x61 architectural?  I thought it a southbridge thing.  In fact I
> > thought with modern chipsets you can access the same thing through port
> > 0x70 or 0x71 (I can't seem to figure out which Intel doc I saw that in).
> > (Not that this conversation has any bearing on your patchset, just an idea
> > I had).
> 
> At least until now, I think port 0x61 can be considered architectural
> (just like we think PIT is architectural before). Maybe in the future it
> will become deprecated and turned into something like a device driver.
> But why not wait until it be.

 This port-mapped I/O register has been first defined by IBM back in 1981 
with their original PC and its 8255 PPI whose port A (at 0x60) served as a 
keyboard interface chip and the remaining ports B (0x61) and C (0x62) were 
used as GPIO (there was also a control register at 0x63, whose purpose was 
to configure the ports; the PPI was a general-purpose chip).  The 
arrangement remained the same with the PC/XT (with the tape recorder 
interface removed ;) ).

 That functionality was then slightly modified and carried over to their 
PC/AT where the functionality previously provided by 8255's port A and 
some GPIO was replaced with an 8042 microcontroller and the remaining GPIO 
was implemented with some discrete glue logic.  With time, as technology 
advanced, that logic was carried over to integrated ASICs like the Intel 
82357 Integrated System Peripheral (ISP) and eventually, with the advent 
of PCI, to the south bridge, alongside all the legacy PC/AT motherboard 
junk I/O (though a discrete 8042 has remained common; these days hanging 
off the LPC bus).

 I am fairly sure you can consider the NMI status register at 0x61 a 
standard cast in stone and I don't think you'll ever find a workstation 
x86 system without one (it also controls the binary speaker, BTW), though 
obviously its presence may vary across embedded x86 systems.  Things may 
of course eventually change if some company decides (and Intel would 
certainly seem capable enough) to get rid of some legacy junk.  I would 
start with getting rid of the 8259A pair first though.

  Maciej
