Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab2KMDtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:49:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56721 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab2KMDtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:49:15 -0500
X-IronPort-AV: E=Sophos;i="4.80,765,1344182400"; 
   d="scan'208";a="6186737"
Message-ID: <50A1B983.2090108@cn.fujitsu.com>
Date: Tue, 13 Nov 2012 11:07:47 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: x86@kernel.org, kexec@lists.infradead.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] x86: clear vmcss on all cpus when doing kdump
 if necessary
References: <50909B55.2070901@cn.fujitsu.com>
In-Reply-To: <50909B55.2070901@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/13 11:09:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/13 11:09:24
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Marcelo,

Do you have any comments about this version?

Thanks
Zhang

于 2012年10月31日 11:30, zhangyanfei 写道:
> Currently, kdump just makes all the logical processors leave VMX operation by
> executing VMXOFF instruction, so any VMCSs active on the logical processors may
> be corrupted. But, sometimes, we need the VMCSs to debug guest images contained
> in the host vmcore. To prevent the corruption, we should VMCLEAR the VMCSs before
> executing the VMXOFF instruction.
> 
> The patch set provides a way to VMCLEAR vmcss related to guests on all cpus before
> executing the VMXOFF when doing kdump. This is used to ensure the VMCSs in the
> vmcore updated and non-corrupted.
> 
> Changelog from v2 to v3:
> 1. remove unnecessary conditions in function
>    cpu_emergency_clear_loaded_vmcss as Marcelo suggested.
> 
> Changelog from v1 to v2:
> 1. remove the sysctl and clear VMCSs unconditionally.
> 
> Zhang Yanfei (2):
>   x86/kexec: VMCLEAR vmcss on all cpus if necessary
>   KVM: make crash_clear_loaded_vmcss valid when loading kvm_intel
>     module
> 
>  arch/x86/include/asm/kexec.h |    2 ++
>  arch/x86/kernel/crash.c      |   25 +++++++++++++++++++++++++
>  arch/x86/kvm/vmx.c           |    9 +++++++++
>  3 files changed, 36 insertions(+), 0 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

