Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094Ab1EMMej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 08:34:39 -0400
Received: from 8bytes.org ([88.198.83.132]:50402 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758865Ab1EMMei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 08:34:38 -0400
Date: Fri, 13 May 2011 14:34:34 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
Message-ID: <20110513123434.GK8707@8bytes.org>
References: <1305129333-7456-1-git-send-email-avi@redhat.com> <20110512093309.GD8707@8bytes.org> <4DCBACC7.8080000@siemens.com> <20110512131130.GG8707@8bytes.org> <4DCBE13A.2050204@redhat.com> <20110512142449.GI8707@8bytes.org> <4DCBF0B7.7080102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCBF0B7.7080102@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 05:37:43PM +0300, Avi Kivity wrote:
> On 05/12/2011 05:24 PM, Joerg Roedel wrote:

> One thing we could do is paravirtualize at a lower level, introduce a  
> hypercall for batch MSR reads and writes.  So we can use the existing  
> PMU semantics and code, just optimize the switch.  This is similar to  
> what Xen did with lazy cpu updates, and what kvm did for paravirt  
> pagetable writes.

In general a good idea. For MSR writes this isn't trivial as well. MSR
reads and writes can cause a #GP, this needs to be represented in this
interface. Can we allow that a batched MSR write changes the operation
mode of the vcpu and so on.
Or we limit this interface to the PMU MSRs, then we are pretty much at
a paravirt-pmu.


> I've considered something similar for mmio - use hypercalls for ordinary  
> mmio to avoid calling into the emulator - but virtio uses pio which  
> isn't emulated and we don't have massive consumers of mmio (except  
> perhaps hpet).
>
> (and we can have a cpuid bit that advertises whether we recommend to use  
> this feature for PMU MSRs; if/when we get hardware support, we turn it 
> off)

A cpuid-bit that indicates which pmu is prefered is certainly a good
idea.

	Joerg

