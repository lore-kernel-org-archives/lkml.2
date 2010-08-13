Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab0HMUKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 16:10:18 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41110 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab0HMUKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 16:10:16 -0400
Subject: Re: [PATCH] kvm: make mmu_shrink() fit shrinker's requirement
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
In-Reply-To: <4C5A844C.60105@redhat.com>
References: <4C591313.50402@cn.fujitsu.com>  <4C5A844C.60105@redhat.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Fri, 13 Aug 2010 13:10:04 -0700
Message-ID: <1281730204.30865.12.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 12:28 +0300, Avi Kivity wrote:
> On 08/04/2010 10:13 AM, Lai Jiangshan wrote:
> > mmu_shrink() should attempt to free @nr_to_scan entries.
> 
> This conflicts with Dave's patchset.
> 
> Dave, what's going on with those patches?  They're starting to smell.

These seem to fix the original problem reporter's issue.  They were run
with 64 guests on a 32GB machine.  No stability problems popped up in
this testing, or since I last sent the patches to you.  The results from
both the test with only the first four patches and with the entire set
of nine looked pretty identical.

That tells me that we should only push the first four for now:

	abstract kvm x86 mmu->n_free_mmu_pages
	rename x86 kvm->arch.n_alloc_mmu_pages
	replace x86 kvm n_free_mmu_pages with n_used_mmu_pages
	create aggregate kvm_total_used_mmu_pages value  


-- Dave

