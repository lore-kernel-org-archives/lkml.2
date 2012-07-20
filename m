Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab2GTC4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 22:56:40 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:49650 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab2GTC4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 22:56:39 -0400
Message-ID: <5008C8DE.4000602@linux.vnet.ibm.com>
Date: Fri, 20 Jul 2012 10:56:30 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 07/10] KVM: introduce readonly_fault_pfn
References: <5005791B.8040807@linux.vnet.ibm.com> <50057A49.8070400@linux.vnet.ibm.com> <5007DE28.2080305@redhat.com>
In-Reply-To: <5007DE28.2080305@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072002-8878-0000-0000-000003528A85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2012 06:15 PM, Avi Kivity wrote:
> On 07/17/2012 05:44 PM, Xiao Guangrong wrote:
>> Introduce readonly_fault_pfn, in the later patch, it indicates failure
>> when we try to get a writable pfn from the readonly memslot
>>
>> +
>>  inline int kvm_is_mmio_pfn(pfn_t pfn)
>>  {
>>  	if (pfn_valid(pfn)) {
>> @@ -949,13 +952,15 @@ EXPORT_SYMBOL_GPL(kvm_disable_largepages);
>>
>>  int is_error_page(struct page *page)
>>  {
>> -	return page == bad_page || page == hwpoison_page || page == fault_page;
>> +	return page == bad_page || page == hwpoison_page || page == fault_page
>> +		|| page == readonly_fault_page;
> 
> All those checks are slow, and get_page(fault_page) etc. isn't very
> scalable.
> 
> We should move to ERR_PTR() etc.  We could use ENOENT, EHWPOISON,
> EFAULT, and EROFS for the above, or maybe there are better matches.
> 

Good point. I will do it in the next version, thank you, Avi!

