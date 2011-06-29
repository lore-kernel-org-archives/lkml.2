Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1F2MGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:06:04 -0400
Received: from ozlabs.org ([203.10.76.45]:48203 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab1F2MGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:06:02 -0400
Date: Wed, 29 Jun 2011 22:05:47 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Joerg Roedel <joro@8bytes.org>, Joerg Roedel <joerg.roedel@amd.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>
Subject: Re: [PATCH 0/5] perf support for amd guest/host-only bits v2
Message-ID: <20110629120547.GS25406@bloggs.ozlabs.ibm.com>
References: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
 <20110628161000.GF29299@8bytes.org>
 <1309338174.6701.929.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309338174.6701.929.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 11:02:54AM +0200, Peter Zijlstra wrote:
> On Tue, 2011-06-28 at 18:10 +0200, Joerg Roedel wrote:
> > On Fri, Jun 17, 2011 at 03:37:29PM +0200, Joerg Roedel wrote:
> > > this is the second version of the patch-set to support the AMD
> > > guest-/host only bits in the performance counter MSRs. Due to lack of
> > > time I havn't looked into emulating support for this feature on Intel or
> > > other architectures, but the other comments should be worked in. The
> > > changes to v1 include:
> > > 
> > > 	* Rebased patches to v3.0-rc3
> > > 	* Allow exclude_guest and exclude_host set at the same time
> > > 	* Reworked event-parse logic for the new exclude-bits
> > > 	* Only count guest-events per default from perf-kvm
> > 
> > Hi Peter, Ingo,
> > 
> > have you had a chance to look at this patch-set? Are any changes
> > required?
> 
> I would feel a lot more comfortable by having it implemented on all of
> x86 as well as at least one !x86 platform. Avi graciously volunteered
> for the Intel bits.  
> 
> Paulus, I hear from benh that you're also responsible for the ppc-kvm
> bits, could you possibly find some time to implement this feature for
> ppc?

I'll have a look at it, but I don't know how quickly I'll be able to
produce a patch.

We have two styles of KVM on PowerPC (at least as far as server
processors are concerned), one where the guest runs entirely in
usermode and the privileged facilities are emulated, and another that
uses hypervisor mode in the host and can allow the guest to use
supervisor mode.  In the latter case, the PMU is considered a guest
resource, that is, the hardware allows the guest to manipulate the PMU
directly, and PMU interrupts go directly to the guest.  In that mode
it's not really possible to count or profile guest activity from the
host.  There are some hypervisor-only counters in the PMU but they
have limited event selection compared to the counters available to the
guest.

Paul.

