Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2LLE14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 23:27:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab2LLE1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 23:27:53 -0500
Date: Tue, 11 Dec 2012 21:36:41 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] KVM: x86: improve reexecute_instruction
Message-ID: <20121211233641.GA14520@amt.cnet>
References: <50C5A747.1020105@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C5A747.1020105@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 05:11:35PM +0800, Xiao Guangrong wrote:
> Changelog:
> There are some changes from Marcelo and Gleb's review, thank you all!
> - access indirect_shadow_pages in the protection of mmu-lock
> - fix the issue when unhandleable instruction access on large page
> - add a new test case for large page
> 
> The current reexecute_instruction can not well detect the failed instruction
> emulation. It allows guest to retry all the instructions except it accesses
> on error pfn.
> 
> For example, these cases can not be detected:
> - for tdp used
>   currently, it refused to retry all instructions. If nested npt is used, the
>   emulation may be caused by shadow page, it can be fixed by unshadow the
>   shadow page.
> 
> - for shadow mmu
>   some cases are nested-write-protect, for example, if the page we want to
>   write is used as PDE but it chains to itself. Under this case, we should
>   stop the emulation and report the case to userspace.
> 
> There are two test cases based on kvm-unit-test can trigger a infinite loop on
> current code (ept = 0), after this patchset, it can report the error to Qemu.
> 
> Subject: [PATCH] access test: test unhandleable instruction
> 
> Test the instruction which can not be handled by kvm
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Please submit the test for inclusion. There should be some way to make
it fail.. program a timer interrupt and #GP? 

