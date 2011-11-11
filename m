Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab1KKP1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 10:27:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab1KKP1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 10:27:04 -0500
Message-ID: <4EBD3ED8.9010005@suse.de>
Date: Fri, 11 Nov 2011 16:27:20 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc <kvm-ppc@vger.kernel.org>
Subject: Re: [PATCH] KVM: PPC: e500: Casting (void *) value returned by kmalloc
 is useless
References: <1320779766.8062.143.camel@localhost.localdomain>	 <4EBD2BB4.3030804@suse.de> <1321025097.20155.118.camel@localhost.localdomain>
In-Reply-To: <1321025097.20155.118.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 04:24 PM, Thomas Meyer wrote:
> Am Freitag, den 11.11.2011, 15:05 +0100 schrieb Alexander Graf:
>> On 11/08/2011 08:15 PM, Thomas Meyer wrote:
>>> From: Thomas Meyer<thomas@m3y3r.de>
>>>
>>>    Casting (void *) value returned by kmalloc is useless
>>>    as mentioned in Documentation/CodingStyle, Chap 14.
>>>
>>>    The semantic patch that makes this change is available
>>>    in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.
>>>
>>>    More information about semantic patching is available at
>>>    http://coccinelle.lip6.fr/
>>>
>>> Signed-off-by: Thomas Meyer<thomas@m3y3r.de>
>>> ---
>>>
>>> diff -u -p a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
>>> --- a/arch/powerpc/kvm/e500_tlb.c 2011-11-07 19:37:27.329638682 +0100
>>> +++ b/arch/powerpc/kvm/e500_tlb.c 2011-11-08 09:18:39.955928218 +0100
>>> @@ -1026,11 +1026,11 @@ int kvmppc_e500_tlb_init(struct kvmppc_v
>>>    	if (vcpu_e500->gtlb_arch[1] == NULL)
>>>    		goto err_out_guest0;
>>>
>>> -	vcpu_e500->gtlb_priv[0] = (struct tlbe_priv *)
>>> +	vcpu_e500->gtlb_priv[0] =
>>>    		kzalloc(sizeof(struct tlbe_priv) * KVM_E500_TLB0_SIZE, GFP_KERNEL);
>>>    	if (vcpu_e500->gtlb_priv[0] == NULL)
>>>    		goto err_out_guest1;
>>> -	vcpu_e500->gtlb_priv[1] = (struct tlbe_priv *)
>>> +	vcpu_e500->gtlb_priv[1] =
>>>    		kzalloc(sizeof(struct tlbe_priv) * KVM_E500_TLB1_SIZE, GFP_KERNEL);
>> Sorry, I can't seem to find that code anywhere. I suppose you're using
>> an old git checkout?
> No, I'm at 3.2-rc1:
>
> https://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=arch/powerpc/kvm/e500_tlb.c#l1029

Ah, yes, that's old. I'm behind Avi's tree, so changes take a while to 
trickle through to Linus. Please check out the following (current 
development) tree:

git://github.com/agraf/linux-2.6.git kvm-ppc-next

Alex


