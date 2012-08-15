Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab2HOQeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:34:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50121 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab2HOQeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:34:09 -0400
Date: Wed, 15 Aug 2012 17:34:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alex Shi <alex.shi@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120815163400.GC14534@srcf.ucam.org>
References: <5028F12C.7080405@intel.com>
 <1345028738.31459.82.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345028738.31459.82.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 01:05:38PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-08-13 at 20:21 +0800, Alex Shi wrote:
> > It bases on the following assumption:
> > 1, If there are many task crowd in system, just let few domain cpus
> > running and let other cpus idle can not save power. Let all cpu take the
> > load, finish tasks early, and then get into idle. will save more power
> > and have better user experience.
> 
> I'm not sure this is a valid assumption. I've had it explained to me by
> various people that race-to-idle isn't always the best thing. It has to
> do with the cost of switching power states and the duration of execution
> and other such things.

This is affected by Intel's implementation - if there's a single active 
core in the system then you can't put *any* package into the deep 
package C states, and that means you don't get into memory self refresh. 
It's a pretty big difference. But this isn't inherently true, and I 
suspect that any implementation is going to have to handle scenarios 
where the behaviour of one package doesn't influence the behaviour of 
another package.

Long term we probably also need to consider whether migrating pages 
between nodes is worth it. That's going to be especially important as 
systems start implementing ACPI 5's memory power management, which 
effectively lets us cut power to all the RAM attached to a node.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
