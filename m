Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181Ab2C2Lvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:51:38 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:47159 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2C2Lvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:51:32 -0400
Message-ID: <4F744CBD.9000703@linux.vnet.ibm.com>
Date: Thu, 29 Mar 2012 19:51:25 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 02/13] KVM: MMU: abstract spte write-protect
References: <4F742951.7080003@linux.vnet.ibm.com> <4F742999.9080001@linux.vnet.ibm.com> <4F744350.1060007@redhat.com>
In-Reply-To: <4F744350.1060007@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032901-0260-0000-0000-000000C60AF1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 07:11 PM, Avi Kivity wrote:


>> +/* Return true if the spte is dropped. */
>> +static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
>> +			       int *flush)
> 
> bool *flush
> 


Okay, will fix.

>> +{
>> +	u64 spte = *sptep;
>> +
>> +	if (!is_writable_pte(spte))
>> +		return false;
>> +
>> +	*flush |= true;
>> +
>> +	if (large) {
>> +		pgprintk("rmap_write_protect(large): spte %p %llx\n",
>> +			 spte, *spte);
>> +		BUG_ON(!is_large_pte(spte));
>> +
>> +		drop_spte(kvm, sptep);
>> +		--kvm->stat.lpages;
>> +		return true;
>> +	}
> 
> As I mentioned before, write-protecting a large spte is a good idea,
> since it moves some work from protect-time to fault-time, so it reduces
> jitter.  This removes the need for the return value.
> 
> It may also be a good idea to populate the lower level instead of
> dropping the spte.
> 
> All outside this patch set of course.  I'd add those ideas to the wiki
> but it won't let me edit at the moment.
> 


I saw your idea, i will pick it up after this patch if no one does it
at that time. :)

