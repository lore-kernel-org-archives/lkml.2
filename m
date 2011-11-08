Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1KHApb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 19:45:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab1KHApa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 19:45:30 -0500
Date: Mon, 7 Nov 2011 16:30:24 -0800
From: Greg KH <gregkh@suse.de>
To: Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Linux 2.6.32.47
Message-ID: <20111108003024.GA6610@suse.de>
References: <20111107213431.GA8483@kroah.com>
 <1320708564@msgid.manchmal.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320708564@msgid.manchmal.in-ulm.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 12:43:49AM +0100, Christoph Biedl wrote:
> Greg KH wrote...
> 
> > I'm announcing the release of the 2.6.32.47 kernel.
> 
> Unfortunately this does not build anymore on ARM (Debian armel):
> 
>   CHK     include/linux/version.h
>   SYMLINK include/asm -> include/asm-arm
> make[1]: `include/asm-arm/mach-types.h' is up to date.
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `sysdev_resume':
> ledtrig-default-on.c:(.text+0x2a97c): undefined reference to `irq_pm_syscore_resume'
> make: *** [.tmp_vmlinux1] Error 1
> 
> 
> The most likely culprit is
> 
>     commit 0f12a6ad9fa3a03f2bcee36c9cb704821e244c40
>     Author: Ian Campbell <ian.campbell@citrix.com>
>     Date:   Mon Oct 3 15:37:00 2011 +0100
> 
> 	genirq: Add IRQF_RESUME_EARLY and resume such IRQs earlier
> 
> as reverting that commit made the error go away.
> 
> The .config used is attached. FWIW, the target system is a DockStar.
> 
> Sorry for not having checked during the review period, I should have
> done so.

Not good.

Ian, Konrad, any thoughts as to how to fix this?

Christoph, sorry I didn't catch this, I need to get my ARM system back
up and running for simple build things like this.

greg k-h
