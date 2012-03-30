Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726Ab2CaAe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 20:34:58 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:40030 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267Ab2CaAe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 20:34:27 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [GIT PULL] Disintegrate and kill asm/system.h
To: Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Neuling <mikey@neuling.org>, David Howells <dhowells@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, arnd@arndb.de, hpa@zytor.com,
        sfr@canb.auug.org.au
In-Reply-To: <20120330074851.GD26543@linux-sh.org>
References: <5599.1332958811@redhat.com> <30702.1332989444@neuling.org> <1332994469.3010.7.camel@pasglop> <20120330074851.GD26543@linux-sh.org>
Date: Fri, 30 Mar 2012 15:46:17 -0600
Message-Id: <20120330214617.B97523E04A4@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 16:48:52 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> On Thu, Mar 29, 2012 at 03:14:29PM +1100, Benjamin Herrenschmidt wrote:
> > > We are currently getting:
> > > kernel/irq/irqdomain.c: In function 'irq_debugfs_init':
> > > kernel/irq/irqdomain.c:698:63: error: 'powerpc_debugfs_root' undeclared (first use in this function)
> > > kernel/irq/irqdomain.c:698:63: note: each undeclared identifier is reported only once for each function it appears in
> > > 
> > >   ae3a197 Disintegrate asm/system.h for PowerPC
> > > is conflicting with 
> > >   cc79ca6 irq_domain: Move irq_domain code from powerpc to kernel/irq
> > > from Grant's tree.
> > > 
> > > Adding the following patch fixes it for pseries_defconfig, although I'm
> > > not sure it's the right fix.
> > 
> > That will do as a quick fix (Linus, can you take it now ?), however..
> > 
> > > Grant: why does powerpc_debugfs_root appear in generic code?  This seems
> > > very bogus.
> > 
> > Yes, Grant, you should move that to a different (generic) debugfs file,
> > the mapping information is valuable debug data for all architectures
> > that use the remapper, not just powerpc and it's not an ABI (no tool I
> > know of rely on the location of that debugfs file) so feel free to move
> > it around.
> > 
> There is a arch_debugfs_dir defined by linux/debugfs.h, but at the moment
> it's only provided by x86 and sh.

Since this data can be used by any arch now, it doesn't make much
sense to put it in arch_debugfs_dir.  I've put it in
/debug/irq_domain_mapping which should be fine.

g.


-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
