Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab2DKKew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:34:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53164 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab2DKKeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:34:50 -0400
X-IronPort-AV: E=Sophos;i="4.75,405,1330876800"; 
   d="scan'208";a="4730792"
Message-ID: <4F855E3C.9010003@cn.fujitsu.com>
Date: Wed, 11 Apr 2012 18:34:36 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        joerg.roedel@amd.com, dzickus@redhat.com, paul.gortmaker@windriver.com,
        gregkh@suse.de, ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 2/4] KVM: VMX: Add functions to fill VMCSINFO
References: <4F84E0DF.8040206@cn.fujitsu.com> <4F84E365.10201@cn.fujitsu.com> <4F85454E.6020201@redhat.com>
In-Reply-To: <4F85454E.6020201@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 18:34:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 18:34:14
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年04月11日 16:48, Avi Kivity 写道:
> On 04/11/2012 04:50 AM, zhangyanfei wrote:
>> This patch is to implement the feature that at initialization of
>> kvm_intel module, fills VMCSINFO with a VMCS revision identifier,
>> and encoded offsets of VMCS fields. The reason why we put the
>> VMCSINFO processing at the initialization of kvm_intel module
>> is that it's dangerous to rob VMX resources while kvm module is
>> loaded.
> 
> Maybe it should be done by a separate module.
> 

If we put vmcsinfo processing at the initialization of kvm_intel module,
as soon as the kvm_intel module is loaded, VMCSINFO is filled. And it is
because vmcsinfo processing is at the initialization of kvm_intel module,
no kvm guests are running, so it will not rob any VMX resources.

If it is done by a separate module, I am afraid this module may not be
loaded when the kernel needs VMCSINFO.

>> +
>> +	kvm_cpu_vmxon(__pa(per_cpu(vmxarea, raw_smp_processor_id())));
>> +	vmcs_load(vmcs);
> 
> Should do this after writing into the vmcs directly (vmcs_load() may
> cache some information for vmcs_read()).
>

Hmm, thanks for pointing this.

