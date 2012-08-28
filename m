Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2H1HTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 03:19:11 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:54280 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2H1HTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 03:19:09 -0400
Message-ID: <503C708A.3010102@linux.vnet.ibm.com>
Date: Tue, 28 Aug 2012 12:47:30 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: tony.luck@intel.com, andi@firstfloor.org, gong.chen@linux.intel.com,
        ananth@in.ibm.com, masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lcm@us.ibm.com, mingo@redhat.com,
        tglx@linutronix.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/mce: Pack boolean MCE boot flags into a structure
References: <20120827112503.10313.62594.stgit@localhost.localdomain> <20120827143619.GE27979@aftab.osrc.amd.com> <503B93D2.7090702@linux.vnet.ibm.com> <20120827154741.GI27979@aftab.osrc.amd.com> <503B99C7.3000503@linux.vnet.ibm.com> <20120827163408.GK27979@aftab.osrc.amd.com> <503BAB00.1080708@linux.vnet.ibm.com> <20120827201840.GC9539@aftab.osrc.amd.com>
In-Reply-To: <20120827201840.GC9539@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12082807-9574-0000-0000-0000042A9036
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2012 01:48 AM, Borislav Petkov wrote:
> On Mon, Aug 27, 2012 at 10:44:40PM +0530, Naveen N. Rao wrote:
>> Looks good. Infact, I had actually added mce_ser and mce_disabled
>> into the bitfield, but backed off not wanting to overdo.
>>
>> We could pull in all the other configuration parameters into this
>> structure as long as everyone is ok with this.
>
> Well, if you'd like, you can make one change per patch so that they can
> be easily reviewable.

Ok.

>
>>> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
>>> index a3ac52b29cbf..e5cfd241e508 100644
>>> --- a/arch/x86/include/asm/mce.h
>>> +++ b/arch/x86/include/asm/mce.h
>>> @@ -126,7 +126,6 @@ struct mce_log {
>>>   #define K8_MCE_THRESHOLD_BANK_5    (MCE_THRESHOLD_BASE + 5 * 9)
>>>   #define K8_MCE_THRESHOLD_DRAM_ECC  (MCE_THRESHOLD_BANK_4 + 0)
>>>
>>> -
>>>   #ifdef __KERNEL__
>>>
>>>   extern void mce_register_decode_chain(struct notifier_block *nb);
>>> @@ -169,8 +168,6 @@ DECLARE_PER_CPU(struct device *, mce_device);
>>>   #define MAX_NR_BANKS 32
>>>
>>>   #ifdef CONFIG_X86_MCE_INTEL
>>> -extern int mce_cmci_disabled;
>>> -extern int mce_ignore_ce;
>>>   void mce_intel_feature_init(struct cpuinfo_x86 *c);
>>>   void cmci_clear(void);
>>>   void cmci_reenable(void);
>>> diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
>>> index 6a05c1d327a9..3b25bcf452d9 100644
>>> --- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
>>> +++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
>>> @@ -28,6 +28,15 @@ extern int mce_ser;
>>>
>>>   extern struct mce_bank *mce_banks;
>>>
>>> +struct mce_cfg {
>>> +	__u32	cmci_disabled		: 1,
>>> +		ignore_ce		: 1,
>>> +		dont_log_ce		: 1,
>>> +		__pad			: 29;
>>> +};
>>> +
>>> +extern struct mce_cfg cfg;
>>> +
>>
>> I'd prefer mce_cfg, rather than just cfg. I think it looks clearer
>> to say, for instance, mce_ser.ignore_ce rather than just
>> cfg.ignore_ce where the latter looks more like a global thing. But,
>> of course, the former is more concise...
>
> Yes,
>
> * it is more consise
> * it is private to mce so no ambiguity
> * having identical struct name and variable names is very confusing (at least
>   to me)
>
> so you can do
>
> extern struct mce_cfg m_cfg;
>
> or
>
> extern struct mce_config mcfg;
>
> or similar but please keep struct name and variable name different.

Sure - I thought this was commonly done, but it is indeed confusing. 
I'll change it.


Thanks,
Naveen

>
> Thanks.
>

