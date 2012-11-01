Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab2KAF4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 01:56:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62129 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab2KAF4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 01:56:30 -0400
X-IronPort-AV: E=Sophos;i="4.80,692,1344182400"; 
   d="scan'208";a="6114225"
Message-ID: <50920EB8.3020400@cn.fujitsu.com>
Date: Thu, 01 Nov 2012 13:55:04 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "Hatayama, Daisuke" <d.hatayama@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v3 2/2] KVM: make crash_clear_loaded_vmcss valid when
 loading kvm_intel module
References: <50909B55.2070901@cn.fujitsu.com> <50909C35.9080702@cn.fujitsu.com> <33710E6CAA200E4583255F4FB666C4E20AACCA2F@G01JPEXMBYT03>
In-Reply-To: <33710E6CAA200E4583255F4FB666C4E20AACCA2F@G01JPEXMBYT03>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/01 13:55:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/01 13:55:44,
	Serialize complete at 2012/11/01 13:55:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年10月31日 17:01, Hatayama, Daisuke 写道:
> 
> 
>> -----Original Message-----
>> From: kexec-bounces@lists.infradead.org
>> [mailto:kexec-bounces@lists.infradead.org] On Behalf Of zhangyanfei
>> Sent: Wednesday, October 31, 2012 12:34 PM
>> To: x86@kernel.org; kexec@lists.infradead.org; Avi Kivity; Marcelo
>> Tosatti
>> Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org
>> Subject: [PATCH v3 2/2] KVM: make crash_clear_loaded_vmcss valid when
>> loading kvm_intel module
>>
>> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> 
> [...]
> 
>> @@ -7230,6 +7231,10 @@ static int __init vmx_init(void)
>>  	if (r)
>>  		goto out3;
>>
>> +#ifdef CONFIG_KEXEC
>> +	crash_clear_loaded_vmcss = vmclear_local_loaded_vmcss;
>> +#endif
>> +
> 
> Assignment here cannot cover the case where NMI is initiated after VMX is on in kvm_init and before vmclear_local_loaded_vmcss is assigned, though rare but can happen.
> 

By saying "VMX is on in kvm init", you mean kvm_init enables the VMX feature in the logical processor?
No, only there is a vcpu to be created, kvm will enable the VMX feature.

I think there is no difference with this assignment before or after kvm_init because the vmcs linked
list must be empty before vmx_init is finished.

Thanks
Zhang Yanfei

> What does happen if calling vmclear_local_loaded_vmcss before kvm_init? I think it no problem since the list is initially empty.
> 
>>  	vmx_disable_intercept_for_msr(MSR_FS_BASE, false);
>>  	vmx_disable_intercept_for_msr(MSR_GS_BASE, false);
>>  	vmx_disable_intercept_for_msr(MSR_KERNEL_GS_BASE, true);
>> @@ -7265,6 +7270,10 @@ static void __exit vmx_exit(void)
>>  	free_page((unsigned long)vmx_io_bitmap_b);
>>  	free_page((unsigned long)vmx_io_bitmap_a);
>>
>> +#ifdef CONFIG_KEXEC
>> +	crash_clear_loaded_vmcss = NULL;
>> +#endif
>> +
>>  	kvm_exit();
>>  }
> 
> Also, this is converse to the above.
> 
> Thanks.
> HATAYAMA, Daisuke
> 
> 

