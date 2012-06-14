Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab2FNDGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 23:06:19 -0400
Received: from linux-sh.org ([111.68.239.195]:53554 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880Ab2FNDGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 23:06:17 -0400
Date: Thu, 14 Jun 2012 12:06:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: build failure in Linus' tree
Message-ID: <20120614030606.GC27673@linux-sh.org>
References: <20120614114722.0fd16fb906b6a5503cfbc51a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614114722.0fd16fb906b6a5503cfbc51a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 11:47:22AM +1000, Stephen Rothwell wrote:
> Hi Linus,
> 
> While building Linus' tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from include/asm-generic/bug.h:5:0,
>                  from arch/powerpc/include/asm/bug.h:127,
>                  from arch/powerpc/kernel/head_64.S:31:
> include/linux/kernel.h:44:0: warning: "ALIGN" redefined [enabled by default]
> include/linux/linkage.h:57:0: note: this is the location of the previous definition
> include/linux/sysinfo.h: Assembler messages:
> include/linux/sysinfo.h:7: Error: Unrecognized opcode: `struct'
> include/linux/sysinfo.h:8: Error: Unrecognized opcode: `__kernel_long_t'
> 
> And it went downhill from there :-(
> 
> Caused by commit 3777808873b0 ("bug.h: need linux/kernel.h for
> TAINT_WARN") which, unfortunately never made it into linux-next.
> 
> I have reverted that commit for today (which presumably means that sh
> builds will be broken again).

I'm still unsure as to the best way to fix this, and there was no
response to the original mail I posted about it either:

http://marc.info/?l=linux-kernel&m=133879579014853&w=2

I'll fetch a powerpc cross compiler and see if I can figure out what went
wrong.

We can always bite the bullet and stuff it in the sh thread_info.h, but
that's papering around the issue, and any other TIF_RESTORE_SIGMASK &&
!HAVE_SET_RESTORE_SIGMASK generic bug user will have to use the same
hack.
