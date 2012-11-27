Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab2K0Bz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 20:55:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4238 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932462Ab2K0Bz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:55:27 -0500
X-IronPort-AV: E=Sophos;i="4.83,325,1352044800"; 
   d="scan'208";a="6280063"
Message-ID: <50B41D1C.1010802@cn.fujitsu.com>
Date: Tue, 27 Nov 2012 09:53:32 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Gleb Natapov <gleb@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v8 1/2] x86/kexec: add a new atomic notifier list for
 kdump
References: <50ADE0C2.1000106@cn.fujitsu.com> <50ADE11A.401@cn.fujitsu.com> <87ip8sxuyh.fsf@xmission.com> <20121126172054.GF12969@redhat.com> <87fw3wuuoh.fsf@xmission.com> <20121126175327.GG12969@redhat.com> <87mwy4teh8.fsf@xmission.com> <50B41849.9040103@cn.fujitsu.com> <87haobolvw.fsf@xmission.com>
In-Reply-To: <87haobolvw.fsf@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 09:55:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 09:55:01
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年11月27日 09:49, Eric W. Biederman 写道:
> Zhang Yanfei <zhangyanfei@cn.fujitsu.com> writes:
> 
>> So in summary,
>>
>> 1. a specific callback function instead of a notifier?
> 
> Yes.
> 
>> 2. Instead of calling vmclear_local_loaded_vmcss, the vmclear operation
>>    will just call the vmclear on every vmcss loaded on the cpu?
>>
>>    like below:
>>
>>    static void crash_vmclear_local_loaded_vmcss(void)
>>    {
>>         int cpu = raw_smp_processor_id();
>>         struct loaded_vmcs *v, *n;
>>
>>         if (!crash_local_vmclear_enabled(cpu))
>>                 return;
>>
>>         list_for_each_entry_safe(v, n, &per_cpu(loaded_vmcss_on_cpu, cpu),
>>                                  loaded_vmcss_on_cpu_link)
>>                 vmcs_clear(v->vmcs);
>>    }
>>
>>    right?
> 
> Yeah that looks good.  I would do list_for_each_entry because the list
> isn't changing.

OK.

I will update the patch and resend it.

Zhang


