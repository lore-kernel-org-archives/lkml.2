Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab2HVMJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:09:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab2HVMJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:09:40 -0400
Message-ID: <5034CBFF.5020608@redhat.com>
Date: Wed, 22 Aug 2012 15:09:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 00/12] KVM: introduce readonly memslot
References: <5032F8FD.2020306@linux.vnet.ibm.com>
In-Reply-To: <5032F8FD.2020306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 05:57 AM, Xiao Guangrong wrote:
> Changelog:
> - fix endless retrying for unhandleable instruction which accesses on readonly
>   host memory
> - divide slot->flags by 16:16, the lower part is visible for userspace, the
>   reset is internally used in kvm, and document this in the code
> - check slot->flags for gfn_to_hva_memslot
> 
> The test case can be found at:
> http://lkml.indiana.edu/hypermail/linux/kernel/1207.2/00819/migrate-perf.tar.bz2
> 
> In current code, if we map a readonly memory space from host to guest
> and the page is not currently mapped in the host, we will get a fault-pfn
> and async is not allowed, then the vm will crash.
> 
> As Avi's suggestion, We introduce readonly memory region to map ROM/ROMD
> to the guest, read access is happy for readonly memslot, write access on
> readonly memslot will cause KVM_EXIT_MMIO exit.

Thanks, applied 1-11.


-- 
error compiling committee.c: too many arguments to function
