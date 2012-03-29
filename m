Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab2C2EOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 00:14:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:35919 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab2C2EOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 00:14:46 -0400
Message-ID: <1332994469.3010.7.camel@pasglop>
Subject: Re: [GIT PULL] Disintegrate and kill asm/system.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Neuling <mikey@neuling.org>
Cc: David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, arnd@arndb.de, hpa@zytor.com,
        sfr@canb.auug.org.au
Date: Thu, 29 Mar 2012 15:14:29 +1100
In-Reply-To: <30702.1332989444@neuling.org>
References: <5599.1332958811@redhat.com> <30702.1332989444@neuling.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-29 at 13:50 +1100, Michael Neuling wrote:
> > Here are a bunch of patches to disintegrate asm/system.h into a set of separate
> > bits to relieve the problem of circular inclusion dependencies.
> > 
> > The following changes since commit 437538267b672f9320833907f1b5acbb2605f4be:
> > 
> >   Merge tag 'fbdev-updates-for-3.4' of git://github.com/schandinat/linux-2.6 (2012-03-22 20:43:40 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-asm_system.git split-asm-system_h
> 
> It would have been nice to have this in linux-next for a day or two to
> sort out the merge issues,  hence....
> 
> This seems to have broken linus tree when compiling a pseries_defconfig

Ah yes, I also saw that, I was hoping you would give me today to run
through my test builds.

> We are currently getting:
> kernel/irq/irqdomain.c: In function 'irq_debugfs_init':
> kernel/irq/irqdomain.c:698:63: error: 'powerpc_debugfs_root' undeclared (first use in this function)
> kernel/irq/irqdomain.c:698:63: note: each undeclared identifier is reported only once for each function it appears in
> 
>   ae3a197 Disintegrate asm/system.h for PowerPC
> is conflicting with 
>   cc79ca6 irq_domain: Move irq_domain code from powerpc to kernel/irq
> from Grant's tree.
> 
> Adding the following patch fixes it for pseries_defconfig, although I'm
> not sure it's the right fix.

That will do as a quick fix (Linus, can you take it now ?), however..

> Grant: why does powerpc_debugfs_root appear in generic code?  This seems
> very bogus.

Yes, Grant, you should move that to a different (generic) debugfs file,
the mapping information is valuable debug data for all architectures
that use the remapper, not just powerpc and it's not an ABI (no tool I
know of rely on the location of that debugfs file) so feel free to move
it around.

Cheers,
Ben.


