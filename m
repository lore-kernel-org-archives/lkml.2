Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111Ab2HJDWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 23:22:15 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:46638 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab2HJDWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 23:22:13 -0400
Message-ID: <50247E5A.5040503@linux.vnet.ibm.com>
Date: Fri, 10 Aug 2012 11:22:02 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 03/12] KVM: introduce gfn_to_pfn_memslot_atomic
References: <5020E423.9080004@linux.vnet.ibm.com> <5020E4B0.9090609@linux.vnet.ibm.com> <20120809185047.GB20889@amt.cnet>
In-Reply-To: <20120809185047.GB20889@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081003-8256-0000-0000-000003A7BDB8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2012 02:50 AM, Marcelo Tosatti wrote:
> On Tue, Aug 07, 2012 at 05:49:36PM +0800, Xiao Guangrong wrote:
>> It can instead of hva_to_pfn_atomic
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c       |    5 +----
>>  include/linux/kvm_host.h |    3 ++-
>>  virt/kvm/kvm_main.c      |   14 ++++++++------
>>  3 files changed, 11 insertions(+), 11 deletions(-)
> 
> What if someone needs gfn_to_hva_memslot in the future, which is not
> unlikely?

Marcelo,

We have already had the function gfn_to_hva_memslot in kvm_host.h which
is not directly used on x86. In this patchset, gfn_to_hva_memslot does
not check the slot->flags.

I think we can let it be based on gfn_to_hva_many:
static inline unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot,
                                               gfn_t gfn)
{
	return gfn_to_hva_many(slot, gfn, true);
}

Then all gfn_to_*() functions are based on gfn_to_hva_many in which we
will check slot->flags properly.

