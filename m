Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab0FPQzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:55:05 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57343 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758949Ab0FPQzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:55:03 -0400
Subject: Re: [RFC][PATCH 4/9] create aggregate kvm_total_used_mmu_pages
 value
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <4C188FC0.3050306@redhat.com>
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
	 <20100615135523.25D24A73@kernel.beaverton.ibm.com>
	 <4C188FC0.3050306@redhat.com>
Content-Type: text/plain
Date: Wed, 16 Jun 2010 09:55:00 -0700
Message-Id: <1276707300.6437.17429.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 11:48 +0300, Avi Kivity wrote:
> > +static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
> > +{
> > +     kvm->arch.n_used_mmu_pages += nr;
> > +     kvm_total_used_mmu_pages += nr;
> >    
> 
> Needs an atomic operation, since there's no global lock here.  To avoid 
> bouncing this cacheline around, make the variable percpu and make 
> readers take a sum across all cpus.  Side benefit is that you no longer 
> need an atomic but a local_t, which is considerably cheaper.

We do have the stuff in:

	include/linux/percpu_counter.h

the downside being that they're not precise and they're *HUGE* according
to the comment. :)

It's actually fairly difficult to do a counter which is precise,
scalable, and works well for small CPU counts when NR_CPUS is large.  Do
you mind if we just stick with a plain atomic_t for now?

-- Dave

