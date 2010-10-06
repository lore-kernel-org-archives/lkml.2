Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab0JFU7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:59:40 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48218 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933085Ab0JFU7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:59:38 -0400
Date: Wed, 6 Oct 2010 16:02:36 -0500
From: Sonny Rao <sonnyrao@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, miltonm@bga.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ian Campbell <ian.campbell@citrix.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        linux-kernel@vger.kernel.org, sonnyrao@linux.vnet.ibm.com
Subject: Re: [RESEND PATCH 1/2] IRQ: use cpu_possible_mask rather than
 online_mask in setup_affinity
Message-ID: <20101006210236.GQ13726@us.ibm.com>
References: <1285968378-12805-1-git-send-email-nacc@us.ibm.com>
 <1285968378-12805-2-git-send-email-nacc@us.ibm.com>
 <1286017262.2144.90.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286017262.2144.90.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 02, 2010 at 01:01:02PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-10-01 at 14:26 -0700, Nishanth Aravamudan wrote:
> > The use of online_mask requires architecture code to be hotplug-aware to
> > account for IRQ round-robin'ing. 
> 
> Architectures that support hotplug should be hotplug aware, that's not
> too much to ask imho.

It seems like most architectures support HOTPLUG_CPU
a quick grep for HOTPLUG_CPU in arch shows:
arm
blackfin
ia64
m32r
mips
mn10300
parisc
powerpc
s390
sh
sparc
x86

also see my reply to Thomas -- it appears that many of the interrupt
controller implementations enforce only affinitizing to online cpus

The other point is, as this is generic code, it's making an assumption
that online cpus is the right mask to test against and we know of at
least one case where this isn't quite correct.

> > With user-driven dynamic SMT,
> 
> What's that?

Well, that is basically a feature where we can use CPU hotplug to
force a particular mode on an SMT (hardware multithreaded) processor 

The point here was really that on such multi-threaded processors -- which are
becoming more common -- cpu hotplug can potentially be used fairly
often.


Sonny
