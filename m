Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab1ELMe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 08:34:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab1ELMe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 08:34:26 -0400
Subject: Re: [PATCH] arch/c6x: new architecture port for linux
From: Mark Salter <msalter@redhat.com>
To: Milton Miller <miltonm@bga.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <c64-naming@mdm.bga.com>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
	 <c64-naming@mdm.bga.com>
Content-Type: text/plain
Organization: Red Hat, Inc
Date: Thu, 12 May 2011 08:34:23 -0400
Message-Id: <1305203663.15167.111.camel@deneb.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 20:13 +0000, Milton Miller wrote:
> On Wed, 11 May 2011 around 17:11:19 EST, Mark Salter wrote:
> > This patch series adds support for a new architecture (arch/c6x) to
> > Linux. This architecture supports members of the Texas Instruments
> > family of C64x single and multicore DSPs. The multicore DSPs do not
> > support cache coherancy, so are not suitable for SMP. Also, these are
> > no-mmu processors. This core architecture is VLIW with an instruction
> > set optimized for DSP applications. For details on the processors:
> 
> So all the changelogs talk about C64x but the arch and all the configs
> are called c6x?  Is it that hard to type 2 digits?   Or do you expect
> an additional chip that breaks the C64 but would fit the C6x name?
> 

The full DSP family is C6000. The current port supports C64xx processors
within that family. There are also C67xx processors with floating point
support. Future support for those seem likely as the instruction set is
nearly identical.

> Also, a couple of one liners while preparing my comments on hvc_c6x:
> 
> [09/16] C6X: add kernel files
> 
> in kernel/setup.c you include linux/delay.h multiple times
> 
Okay, I'll get rid of it.

> 
> 
> [11/16] C6X: add lib files
> 
> arch/c6x/lib/memset.c
> 
> (1) file header says linux/arch/c6x/lib/memcmp.c
> (you should probably just delete such headers, they are just maintence errors)

Agreed. I've been removing these as I find them. I need to sweep the
whole code base and get rid of them all.

> 
> (2) it appears to mach lib/string.c implementation except (1) register (2)
> uses post-increment instead of pre-increment.   Does it matter with gcc?
> 
> arch/c6x/lib/memcmp.c
> 	your version returns -1 or 1 while string.c returns the difference
> after promotion to int.   man page for userspace says just integer less
> than or greater, so I guess this is ok.  But is this more efficient,
> or could you use the generic version?

I'm pretty sure the generic versions would be just fine using gcc. There
may have been a reason for them when using the TI toolchain, but it
makes sense to just ditch the c6x versions at this point.

--Mark



