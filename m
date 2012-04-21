Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab2DUGw2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 02:52:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57061 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2DUGw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 02:52:26 -0400
Message-ID: <4F925925.7040806@gmail.com>
Date: Sat, 21 Apr 2012 14:52:21 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/9] KVM: MMU: abstract spte write-protect
References: <4F911B74.4040305@linux.vnet.ibm.com> <4F911BAB.6000206@linux.vnet.ibm.com> <20120420213319.GA13817@amt.cnet> <4F922886.5060807@gmail.com> <20120421041854.GA2763@amt.cnet>
In-Reply-To: <20120421041854.GA2763@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2012 12:18 PM, Marcelo Tosatti wrote:

> On Sat, Apr 21, 2012 at 11:24:54AM +0800, Xiao Guangrong wrote:
>> On 04/21/2012 05:33 AM, Marcelo Tosatti wrote:
>>
>>
>>>>  static bool
>>>>  __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
>>>>  {
>>>> @@ -1050,24 +1078,13 @@ __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
>>>>
>>>>  	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
>>>>  		BUG_ON(!(*sptep & PT_PRESENT_MASK));
>>>> -		rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
>>>> -
>>>> -		if (!is_writable_pte(*sptep)) {
>>>> -			sptep = rmap_get_next(&iter);
>>>> -			continue;
>>>> -		}
>>>> -
>>>> -		if (level == PT_PAGE_TABLE_LEVEL) {
>>>> -			mmu_spte_update(sptep, *sptep & ~PT_WRITABLE_MASK);
>>>> -			sptep = rmap_get_next(&iter);
>>>> -		} else {
>>>> -			BUG_ON(!is_large_pte(*sptep));
>>>> -			drop_spte(kvm, sptep);
>>>> -			--kvm->stat.lpages;
>>>
>>> It is preferable to remove all large sptes including read-only ones, the
>>
>>
>> It can cause page faults even if read memory on these large sptse.
>>
>> Actually, Avi suggested that make large writable spte to be readonly
>> (not dropped) on this path.
> 
> See commits e49146dce8c3dc6f4485c1904b6587855f393e71,
> 38187c830cab84daecb41169948467f1f19317e3 for issues
> with large read-only sptes.
> 


Yes, we need check the code carefully when change writable spte to be
read-only, let us discuss it in the separate patchset later. :)

