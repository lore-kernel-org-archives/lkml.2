Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1ASRuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:50:01 -0500
Received: from canuck.infradead.org ([134.117.69.58]:45612 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab1ASRuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:50:00 -0500
Subject: Re: [PATCH 2/3] kvm hypervisor : Add hypercalls to support
 pv-ticketlock
From: Peter Zijlstra <peterz@infradead.org>
To: vatsa@linux.vnet.ibm.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        kvm@vger.kernel.org, suzuki@in.ibm.com
In-Reply-To: <20110119172306.GA2863@linux.vnet.ibm.com>
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
	 <20110119164432.GA30669@linux.vnet.ibm.com>
	 <20110119171239.GB726@linux.vnet.ibm.com>
	 <20110119172306.GA2863@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 Jan 2011 18:50:15 +0100
Message-ID: <1295459415.28776.146.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 22:53 +0530, Srivatsa Vaddagiri wrote:
> On Wed, Jan 19, 2011 at 10:42:39PM +0530, Srivatsa Vaddagiri wrote:
> > Add two hypercalls to KVM hypervisor to support pv-ticketlocks.
> > 
> > KVM_HC_WAIT_FOR_KICK blocks the calling vcpu until another vcpu kicks it or it
> > is woken up because of an event like interrupt.
> 
> One possibility is to extend this hypercall to do a directed yield as well, 
> which needs some more thought. Another issue that needs to be resolved with
> pv-ticketlocks is the impact on intra-VM fairness. A guest experiencing heavy
> contention can keep yielding cpu, allowing other VMs to get more time than they
> deserve.

No, yield sucks, if you know the owner you can do actual PI.
