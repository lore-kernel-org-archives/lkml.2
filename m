Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529Ab0E0SrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:47:16 -0400
Received: from pqueuea.post.tele.dk ([193.162.153.9]:59171 "EHLO
	pqueuea.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759428Ab0E0SrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:47:15 -0400
Date: Thu, 27 May 2010 20:46:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
Message-ID: <20100527184653.GA11830@merkur.ravnborg.org>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com> <20100527154916.GA5585@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527154916.GA5585@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 11:49:16AM -0400, Christoph Hellwig wrote:
> On Thu, May 27, 2010 at 05:37:36AM +0530, Jaswinder Singh Rajput wrote:
> > Hello,
> > 
> > I am trying to build 32 bit kernel image on 64-bit machine but after
> > 'make menuconfig' it automatically switches 32-bit to 64-bit.
> > 
> > Is this a BUG or did intentionally.
> 
> I think it's intentional, but I'm really annoyed by this behaviour.

The request when we did the merge of 32 and 64 bit was that we
should continue to build 64bit kernels on 64 bit machines.
And likewise for 32bit.
Because this was what the users where used to.

We could simplify metters by defining new rules.
As you suggest that uname on an intel box always resulted in ARCH=x86.
But then people would complain why a 32 bit kernel is default when
the box is 64 bit.

Something like this:
[The escape chars align nicely in the patched Makefile]

	Sam

diff --git a/Makefile b/Makefile
index ebc8225..e7f97a5 100644
--- a/Makefile
+++ b/Makefile
@@ -161,10 +161,11 @@ export srctree objtree VPATH
 # then ARCH is assigned, getting whatever value it gets normally, and 
 # SUBARCH is subsequently ignored.
 
-SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
-				  -e s/arm.*/arm/ -e s/sa110/arm/ \
+SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/        \
+				  -e s/sun4u/sparc64/                    \
+				  -e s/arm.*/arm/ -e s/sa110/arm/        \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
-				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
+				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/  \
 				  -e s/sh[234].*/sh/ )
 
 # Cross compiling and selecting different set of gcc/bin-utils

