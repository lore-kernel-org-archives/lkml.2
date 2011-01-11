Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1AKNd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 08:33:29 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48690 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932138Ab1AKNd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 08:33:26 -0500
Date: Tue, 11 Jan 2011 14:33:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 00/17] pramfs: persistent and protected RAM filesystem
Message-ID: <20110111133325.GC10705@atrey.karlin.mff.cuni.cz>
References: <4D25AEEE.1050401@gmail.com> <1294322613.2016.333.camel@laptop> <4D25ED22.3070900@gmail.com> <4D25F4CF.1030009@gmail.com> <987664A83D2D224EAE907B061CE93D530193FC6AA2@orsmsx505.amr.corp.intel.com> <4D260A96.4020400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D260A96.4020400@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Il 06/01/2011 19:22, Luck, Tony ha scritto:
> >> Errata corrige: maybe I used the wrong term, I meant "volatile" instead
> >> of "temporary" information, i.e. I'd like to save this info to re-read
> >> it later but I don't want to store it in flash, a simple log, run-time
> >> information for debug like a flight-recorder or whatever you want.
> > 
> > I'm puzzled by the use of "a generic piece of memory" to store "persistent"
> > things (Perhaps this is made clear in the 17 parts of the patch? I haven't
> > read them yet).  On x86 f/w typically clears all of memory on reset ... so
> > you only get persistence if you use kexec to get from the old kernel to
> > the new one.
> > 
> > -Tony
> > 
> 
> First of all, you can find a lot of information on the web site where
> there is an overview and a page with implementation details, benchmark
> and so on. With "a generic piece of memory" I mean a generic memory
> device directly addressable. Usually this generic device is an NVRAM, so
> we have a persistent store. If you haven't got this hw you can use other
> devices or the classic RAM, in this case you have a fs persistent only
> over reboot. The use of this fs is mainly for embedded systems, fw can
> be configured to not clear *all* the memory. Pramfs is indeed supported
> by U-Boot, you can see CONFIG_PRAM in the Das U-Boot manual. x86 in this
> case can be a "strange" world for this fs, but however if the user wants
> it can be used without problems because there aren't neither strict arch
> or hw dependency.

Actually you probably want to state u-boot compatibility in the commit
message. AFAICT, that is quite good argument _for_ inclusion.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
