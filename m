Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab2C3Hti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 03:49:38 -0400
Received: from linux-sh.org ([111.68.239.195]:39777 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759331Ab2C3Hta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 03:49:30 -0400
Date: Fri, 30 Mar 2012 16:48:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Neuling <mikey@neuling.org>, David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, arnd@arndb.de, hpa@zytor.com,
        sfr@canb.auug.org.au
Subject: Re: [GIT PULL] Disintegrate and kill asm/system.h
Message-ID: <20120330074851.GD26543@linux-sh.org>
References: <5599.1332958811@redhat.com> <30702.1332989444@neuling.org> <1332994469.3010.7.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332994469.3010.7.camel@pasglop>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 03:14:29PM +1100, Benjamin Herrenschmidt wrote:
> > We are currently getting:
> > kernel/irq/irqdomain.c: In function 'irq_debugfs_init':
> > kernel/irq/irqdomain.c:698:63: error: 'powerpc_debugfs_root' undeclared (first use in this function)
> > kernel/irq/irqdomain.c:698:63: note: each undeclared identifier is reported only once for each function it appears in
> > 
> >   ae3a197 Disintegrate asm/system.h for PowerPC
> > is conflicting with 
> >   cc79ca6 irq_domain: Move irq_domain code from powerpc to kernel/irq
> > from Grant's tree.
> > 
> > Adding the following patch fixes it for pseries_defconfig, although I'm
> > not sure it's the right fix.
> 
> That will do as a quick fix (Linus, can you take it now ?), however..
> 
> > Grant: why does powerpc_debugfs_root appear in generic code?  This seems
> > very bogus.
> 
> Yes, Grant, you should move that to a different (generic) debugfs file,
> the mapping information is valuable debug data for all architectures
> that use the remapper, not just powerpc and it's not an ABI (no tool I
> know of rely on the location of that debugfs file) so feel free to move
> it around.
> 
There is a arch_debugfs_dir defined by linux/debugfs.h, but at the moment
it's only provided by x86 and sh.
