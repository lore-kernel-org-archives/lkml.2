Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab0KZMRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:17:39 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:34226 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab0KZMRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:17:38 -0500
Date: Fri, 26 Nov 2010 13:17:34 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        Horst Hartmann <horsth@linux.vnet.ibm.com>, stable@kernel.org
Subject: Re: [patch 3/3] nohz/s390: fix arch_needs_cpu() return value on
 offline cpus
Message-ID: <20101126121734.GB7023@osiris.boeblingen.de.ibm.com>
References: <20101126120057.879397696@de.ibm.com>
 <20101126120235.738301376@de.ibm.com>
 <1290773647.2145.140.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290773647.2145.140.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 01:14:07PM +0100, Peter Zijlstra wrote:
> On Fri, 2010-11-26 at 13:01 +0100, Heiko Carstens wrote:
> > plain text document attachment (003_arch_needs_cpu.diff)
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > This fixes the same problem as described in the patch "nohz: fix
> > printk_needs_cpu() return value on offline cpus" for the arch_needs_cpu()
> > primitive.
> > This specific bug was indrocuded with 3c5d92a0 "nohz: Introduce arch_needs_cpu".
> > 
> > In this case a cpu hotplug notifier is used to fix the issue in order to keep
> > the normal/fast path small. All we need to do is to clear the condition that
> > makes arch_needs_cpu() return 1 since it is just a performance improvement which
> > is supposed to keep the local tick running for a short period if a cpu goes
> > idle. Nothing special needs to be done except for clearing the condition.
> > 
> > Cc: stable@kernel.org
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> OK, and s390 seems to be the only architecture making use of that
> interface.
> 
> Did you audit all the other *_needs_cpu() interfaces for this same
> problem?

There's only rcu_needs_cpu() left and rcu indeed has a cpu hotplug notifier.
So there _shouldn't_ be any problems with that.

> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Will you take this through the s390?

Yes. Thanks!
