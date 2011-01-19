Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1ASRXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:23:17 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56892 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab1ASRXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:23:15 -0500
Date: Wed, 19 Jan 2011 22:53:07 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        kvm@vger.kernel.org, suzuki@in.ibm.com
Subject: Re: [PATCH 2/3] kvm hypervisor : Add hypercalls to support
 pv-ticketlock
Message-ID: <20110119172306.GA2863@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <20110119164432.GA30669@linux.vnet.ibm.com>
 <20110119171239.GB726@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119171239.GB726@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 10:42:39PM +0530, Srivatsa Vaddagiri wrote:
> Add two hypercalls to KVM hypervisor to support pv-ticketlocks.
> 
> KVM_HC_WAIT_FOR_KICK blocks the calling vcpu until another vcpu kicks it or it
> is woken up because of an event like interrupt.

One possibility is to extend this hypercall to do a directed yield as well, 
which needs some more thought. Another issue that needs to be resolved with
pv-ticketlocks is the impact on intra-VM fairness. A guest experiencing heavy
contention can keep yielding cpu, allowing other VMs to get more time than they
deserve.

- vatsa
