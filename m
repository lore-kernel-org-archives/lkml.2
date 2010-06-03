Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab0FCNa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:30:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:44239 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab0FCNa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:30:57 -0400
Date: Thu, 3 Jun 2010 15:30:55 +0200
From: Michal Marek <mmarek@suse.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
Message-ID: <20100603133055.GA27797@sepie.suse.cz>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com>
 <20100527154916.GA5585@infradead.org>
 <20100527184653.GA11830@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527184653.GA11830@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 08:46:53PM +0200, Sam Ravnborg wrote:
> On Thu, May 27, 2010 at 11:49:16AM -0400, Christoph Hellwig wrote:
> > On Thu, May 27, 2010 at 05:37:36AM +0530, Jaswinder Singh Rajput wrote:
> > > Hello,
> > > 
> > > I am trying to build 32 bit kernel image on 64-bit machine but after
> > > 'make menuconfig' it automatically switches 32-bit to 64-bit.
> > > 
> > > Is this a BUG or did intentionally.
> > 
> > I think it's intentional, but I'm really annoyed by this behaviour.
> 
> The request when we did the merge of 32 and 64 bit was that we
> should continue to build 64bit kernels on 64 bit machines.
> And likewise for 32bit.
> Because this was what the users where used to.
> 
> We could simplify metters by defining new rules.
> As you suggest that uname on an intel box always resulted in ARCH=x86.
> But then people would complain why a 32 bit kernel is default when
> the box is 64 bit.

Which is not acceptable, IMO. An x86_64 distro typically has a complete
64bit userspace including /sbin/init, so the default kernel has to be
64bit.

What about always making the prompt visible, so that the previously set
value gets reused? The downside is that 'make ARCH=i386 menuconfig' in a
clean tree on x86_64 will default to 64bit, because it will find the
setting in the config of the running 64bit kernel :(. But after manually
turning CONFIG_64BIT off, the setting will be preserved.

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dcb0593..05ec418 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -3,7 +3,7 @@ mainmenu "Linux Kernel Configuration for x86"
 
 # Select 32 or 64 bit
 config 64BIT
-	bool "64-bit kernel" if ARCH = "x86"
+	bool "64-bit kernel"
 	default ARCH = "x86_64"
 	---help---
 	  Say yes to build a 64-bit kernel - formerly known as x86_64
