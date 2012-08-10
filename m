Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab2HJSgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 14:36:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759877Ab2HJSgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 14:36:09 -0400
Date: Fri, 10 Aug 2012 15:14:22 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 00/12] KVM: introduce readonly memslot
Message-ID: <20120810181422.GA14892@amt.cnet>
References: <5020E423.9080004@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5020E423.9080004@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 05:47:15PM +0800, Xiao Guangrong wrote:
> Changelog:
> - introduce KVM_PFN_ERR_RO_FAULT instead of dummy page
> - introduce KVM_HVA_ERR_BAD and optimize error hva indicators
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

Memory slots whose QEMU mapping is write protected is supported
today, as long as there are no write faults.

What prevents the use of mmap(!MAP_WRITE) to handle read-only memslots
again?

The initial objective was to fix a vm crash, can you explain that
initial problem?

