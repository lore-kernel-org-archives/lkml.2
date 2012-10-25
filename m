Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab2JYKst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:48:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62406 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757231Ab2JYKsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:48:47 -0400
X-IronPort-AV: E=Sophos;i="4.80,646,1344182400"; 
   d="scan'208";a="6069641"
Message-ID: <508918BF.8040500@cn.fujitsu.com>
Date: Thu, 25 Oct 2012 18:47:27 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: x86@kernel.org, kexec@lists.infradead.org, Avi Kivity <avi@redhat.com>,
        mtosatti@redhat.com
CC: linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] x86: clear vmcss on all cpus when doing kdump
 if necessary
References: <5080E813.7030302@cn.fujitsu.com>
In-Reply-To: <5080E813.7030302@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 18:48:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 18:48:10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would anyone help review the patch, and give some comments, please ? 

Avi?

于 2012年10月19日 13:41, Zhang Yanfei 写道:
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
> Changelog from v1 to v2:
> 1. remove the sysctl and clear VMCSs unconditionally.
> 
> zhangyanfei (2):
>   x86/kexec: VMCLEAR vmcss on all cpus if necessary
>   KVM: make crash_clear_loaded_vmcss valid when loading kvm_intel
>     module
> 
>  arch/x86/include/asm/kexec.h |    2 ++
>  arch/x86/kernel/crash.c      |   27 +++++++++++++++++++++++++++
>  arch/x86/kvm/vmx.c           |    9 +++++++++
>  3 files changed, 38 insertions(+), 0 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

