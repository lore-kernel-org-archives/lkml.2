Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab2GBPwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:52:22 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25355 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2GBPwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:52:20 -0400
Date: Mon, 2 Jul 2012 11:42:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hillf Danton <dhillf@gmail.com>,
        Dan Smith <danms@us.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 11/40] autonuma: define the autonuma flags
Message-ID: <20120702154222.GA26953@phenom.dumpdata.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
 <1340888180-15355-12-git-send-email-aarcange@redhat.com>
 <20120630045825.GC3975@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120630045825.GC3975@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2012 at 12:58:25AM -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, Jun 28, 2012 at 02:55:51PM +0200, Andrea Arcangeli wrote:
> > These flags are the ones tweaked through sysfs, they control the
> > behavior of autonuma, from enabling disabling it, to selecting various
> > runtime options.
> > 
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> > ---
> >  include/linux/autonuma_flags.h |   62 ++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 62 insertions(+), 0 deletions(-)
> >  create mode 100644 include/linux/autonuma_flags.h
> > 
> > diff --git a/include/linux/autonuma_flags.h b/include/linux/autonuma_flags.h
> > new file mode 100644
> > index 0000000..5e29a75
> > --- /dev/null
> > +++ b/include/linux/autonuma_flags.h
> > @@ -0,0 +1,62 @@
> > +#ifndef _LINUX_AUTONUMA_FLAGS_H
> > +#define _LINUX_AUTONUMA_FLAGS_H
> > +
> > +enum autonuma_flag {
> 
> These aren't really flags. They are bit-fields.
> A
> > +	AUTONUMA_FLAG,
> 
> Looking at the code, this is to turn it on. Perhaps a better name such
> as: AUTONUMA_ACTIVE_FLAG ?
> 
> 
> > +	AUTONUMA_IMPOSSIBLE_FLAG,
> > +	AUTONUMA_DEBUG_FLAG,
> > +	AUTONUMA_SCHED_LOAD_BALANCE_STRICT_FLAG,
> 
> I might have gotten my math wrong, but if you have
> AUTONUMA_SCHED_LOAD_BALACE.. set (so 3), that also means
> that bit 0 and 1 are on. In other words AUTONUMA_FLAG
> and AUTONUMA_IMPOSSIBLE_FLAG are turned on.
> 
> > +	AUTONUMA_SCHED_CLONE_RESET_FLAG,
> > +	AUTONUMA_SCHED_FORK_RESET_FLAG,
> > +	AUTONUMA_SCAN_PMD_FLAG,
> 
> So this is 6, which means 110 bits. So AUTONUMA_FLAG
> gets turned off.

Ignore that pls. I had in my mind that test_bit was doing boolean logic (anding and masking,
and such), but that is not the case.
