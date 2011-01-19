Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1ASRVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:21:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:60961 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab1ASRVf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:21:35 -0500
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
In-Reply-To: <20110119171239.GB726@linux.vnet.ibm.com>
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
	 <20110119164432.GA30669@linux.vnet.ibm.com>
	 <20110119171239.GB726@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 Jan 2011 18:21:12 +0100
Message-ID: <1295457672.28776.144.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 22:42 +0530, Srivatsa Vaddagiri wrote:
> Add two hypercalls to KVM hypervisor to support pv-ticketlocks.
> 
> KVM_HC_WAIT_FOR_KICK blocks the calling vcpu until another vcpu kicks it or it
> is woken up because of an event like interrupt.
> 
> KVM_HC_KICK_CPU allows the calling vcpu to kick another vcpu.
> 
> The presence of these hypercalls is indicated to guest via
> KVM_FEATURE_WAIT_FOR_KICK/KVM_CAP_WAIT_FOR_KICK. Qemu needs a corresponding
> patch to pass up the presence of this feature to guest via cpuid. Patch to qemu
> will be sent separately.


I didn't really read the patch, and I totally forgot everything from
when I looked at the Xen series, but does the Xen/KVM hypercall
interface for this include the vcpu to await the kick from?

My guess is not, since the ticket locks used don't know who the owner
is, which is of course, sad. There are FIFO spinlock implementations
that can do this though.. although I think they all have a bigger memory
footprint.

The reason for wanting this should be clear I guess, it allows PI.
