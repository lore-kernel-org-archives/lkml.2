Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab0ELRE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:04:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab0ELRE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:04:56 -0400
Date: Wed, 12 May 2010 14:04:47 -0300
From: Glauber Costa <glommer@redhat.com>
To: Alexander Graf <agraf@suse.de>
Cc: Zachary Amsden <zamsden@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH 0/9] pvclock misc fixes - v4.
Message-ID: <20100512170447.GC14463@mothafucka.localdomain>
References: <1273594667-17175-1-git-send-email-glommer@redhat.com>
 <4BEA21A1.8040702@redhat.com>
 <AFD76714-2559-4281-AB61-EA5C6395C13A@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AFD76714-2559-4281-AB61-EA5C6395C13A@suse.de>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 07:47:39AM +0200, Alexander Graf wrote:
> 
> On 12.05.2010, at 05:33, Zachary Amsden wrote:
> 
> > On 05/11/2010 06:17 AM, Glauber Costa wrote:
> >> This is the fourth version ov kvmclock fixes.
> >> 
> >> Just two minor changes in patch 5, per avi request, and
> >> the addition of cpuid.txt file, documenting all cpuid flags
> >> we use.
> >> 
> >> As a side effect, this patch removes the time-travel feature
> >> in kvm guests.
> >> 
> >> Glauber Costa (9):
> >>   Enable pvclock flags in vcpu_time_info structure
> >>   Add a global synchronization point for pvclock
> >>   change msr numbers for kvmclock
> >>   add new KVMCLOCK cpuid feature
> >>   export paravirtual cpuid flags in KVM_GET_SUPPORTED_CPUID
> >>   Try using new kvm clock msrs
> >>   don't compute pvclock adjustments if we trust the tsc
> >>   Tell the guest we'll warn it about tsc stability
> >>   Add cpuid.txt file
> >> 
> >>  Documentation/kvm/cpuid.txt        |   44 ++++++++++++++++++++++++++++
> >>  arch/x86/include/asm/kvm_para.h    |   13 ++++++++
> >>  arch/x86/include/asm/pvclock-abi.h |    4 ++-
> >>  arch/x86/include/asm/pvclock.h     |    1 +
> >>  arch/x86/kernel/kvmclock.c         |   56 ++++++++++++++++++++++-------------
> >>  arch/x86/kernel/pvclock.c          |   37 +++++++++++++++++++++++
> >>  arch/x86/kvm/x86.c                 |   44 +++++++++++++++++++++++++++-
> >>  7 files changed, 176 insertions(+), 23 deletions(-)
> >>  create mode 100644 Documentation/kvm/cpuid.txt
> >> 
> >>   
> > Acked-by: Zachary Amsden <zamsden@redhat.com>
> 
> 
> How about stable queuing of this one?
I don't think the MSR part classifies for stable.

The sync part, that might.
