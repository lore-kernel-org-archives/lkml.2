Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126Ab0FPPmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:42:39 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58064 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759097Ab0FPPmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:42:38 -0400
Subject: Re: [RFC][PATCH 3/9] replace x86 kvm n_free_mmu_pages with
 n_used_mmu_pages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20100616142541.GB1662@amt.cnet>
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
	 <20100615135522.892D6BFE@kernel.beaverton.ibm.com>
	 <20100616142541.GB1662@amt.cnet>
Content-Type: text/plain
Date: Wed, 16 Jun 2010 08:42:28 -0700
Message-Id: <1276702948.6437.17047.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 11:25 -0300, Marcelo Tosatti wrote:
> > -     if (used_pages > kvm_nr_mmu_pages) {
> > -             while (used_pages > kvm_nr_mmu_pages &&
> > +     if (kvm->arch.n_used_mmu_pages > goal_nr_mmu_pages) {
> > +             while (kvm->arch.n_used_mmu_pages > goal_nr_mmu_pages &&
> >                       !list_empty(&kvm->arch.active_mmu_pages)) {
> >                       struct kvm_mmu_page *page;
> >  
> >                       page = container_of(kvm->arch.active_mmu_pages.prev,
> >                                           struct kvm_mmu_page, link);
> > -                     used_pages -= kvm_mmu_zap_page(kvm, page);
> > -                     used_pages--;
> > +                     kvm->arch.n_used_mmu_pages -= kvm_mmu_zap_page(kvm, page);
> > +                     kvm->arch.n_used_mmu_pages--;
> 
> kvm->arch.n_used_mmu_pages is deaccounted for in kvm_mmu_zap_page ->
> kvm_mmu_free_page
> already.

Ahh, I see that now.  Thanks!

-- Dave

