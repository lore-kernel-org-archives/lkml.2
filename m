Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab2K0Btw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 20:49:52 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47022 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab2K0Btv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:49:51 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Gleb Natapov <gleb@redhat.com>, "x86\@kernel.org" <x86@kernel.org>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
References: <50ADE0C2.1000106@cn.fujitsu.com> <50ADE11A.401@cn.fujitsu.com>
	<87ip8sxuyh.fsf@xmission.com> <20121126172054.GF12969@redhat.com>
	<87fw3wuuoh.fsf@xmission.com> <20121126175327.GG12969@redhat.com>
	<87mwy4teh8.fsf@xmission.com> <50B41849.9040103@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 19:49:39 -0600
In-Reply-To: <50B41849.9040103@cn.fujitsu.com> (Zhang Yanfei's message of
	"Tue, 27 Nov 2012 09:32:57 +0800")
Message-ID: <87haobolvw.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19vQzZpsOXJchO+qTEOw3jl1FCZ93lDhls=
X-SA-Exim-Connect-IP: 75.135.205.0
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v8 1/2] x86/kexec: add a new atomic notifier list for kdump
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Yanfei <zhangyanfei@cn.fujitsu.com> writes:

> So in summary,
>
> 1. a specific callback function instead of a notifier?

Yes.

> 2. Instead of calling vmclear_local_loaded_vmcss, the vmclear operation
>    will just call the vmclear on every vmcss loaded on the cpu?
>
>    like below:
>
>    static void crash_vmclear_local_loaded_vmcss(void)
>    {
>         int cpu = raw_smp_processor_id();
>         struct loaded_vmcs *v, *n;
>
>         if (!crash_local_vmclear_enabled(cpu))
>                 return;
>
>         list_for_each_entry_safe(v, n, &per_cpu(loaded_vmcss_on_cpu, cpu),
>                                  loaded_vmcss_on_cpu_link)
>                 vmcs_clear(v->vmcs);
>    }
>
>    right?

Yeah that looks good.  I would do list_for_each_entry because the list
isn't changing.

Eric
