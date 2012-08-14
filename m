Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab2HNOAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:00:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab2HNOAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:00:38 -0400
Message-ID: <502A5A01.6040505@redhat.com>
Date: Tue, 14 Aug 2012 17:00:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 00/12] KVM: introduce readonly memslot
References: <5020E423.9080004@linux.vnet.ibm.com> <20120810181422.GA14892@amt.cnet>
In-Reply-To: <20120810181422.GA14892@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2012 09:14 PM, Marcelo Tosatti wrote:
> On Tue, Aug 07, 2012 at 05:47:15PM +0800, Xiao Guangrong wrote:
>> Changelog:
>> - introduce KVM_PFN_ERR_RO_FAULT instead of dummy page
>> - introduce KVM_HVA_ERR_BAD and optimize error hva indicators
>> 
>> The test case can be found at:
>> http://lkml.indiana.edu/hypermail/linux/kernel/1207.2/00819/migrate-perf.tar.bz2
>> 
>> In current code, if we map a readonly memory space from host to guest
>> and the page is not currently mapped in the host, we will get a fault-pfn
>> and async is not allowed, then the vm will crash.
>> 
>> As Avi's suggestion, We introduce readonly memory region to map ROM/ROMD
>> to the guest, read access is happy for readonly memslot, write access on
>> readonly memslot will cause KVM_EXIT_MMIO exit.
> 
> Memory slots whose QEMU mapping is write protected is supported
> today, as long as there are no write faults.
> 
> What prevents the use of mmap(!MAP_WRITE) to handle read-only memslots
> again?

Userspace may want to modify the ROM (for example, when programming a
flash device).  It is also possible to map an hva range rw through one
slot and ro through another.


-- 
error compiling committee.c: too many arguments to function
