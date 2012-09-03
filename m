Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab2ICLNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 07:13:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254Ab2ICLN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 07:13:28 -0400
Message-ID: <504490CE.5060507@redhat.com>
Date: Mon, 03 Sep 2012 14:13:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Dong Hao <haodong@linux.vnet.ibm.com>
CC: acme@infradead.org, mtosatti@redhat.com, mingo@elte.hu,
        xiaoguangrong@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 1/3] KVM: x86: export svm/vmx exit code and vector
 code to userspace
References: <1346061106-5364-1-git-send-email-haodong@linux.vnet.ibm.com> <1346061106-5364-2-git-send-email-haodong@linux.vnet.ibm.com>
In-Reply-To: <1346061106-5364-2-git-send-email-haodong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 12:51 PM, Dong Hao wrote:
> From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> 
> Exporting KVM exit information to userspace to be consumed by perf.
> 
> [ Dong Hao <haodong@linux.vnet.ibm.com>: rebase it on acme's git tree ]
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   36 ++++---

Please put ABIs in kvm.h.  But see below.

>  arch/x86/include/asm/svm.h      |  205 +++++++++++++++++++++++++--------------
>  arch/x86/include/asm/vmx.h      |  126 ++++++++++++++++--------
>  arch/x86/kvm/trace.h            |   89 -----------------
>  4 files changed, 234 insertions(+), 222 deletions(-)
> 
>  
> +#define DE_VECTOR 0
> +#define DB_VECTOR 1
> +#define BP_VECTOR 3
> +#define OF_VECTOR 4
> +#define BR_VECTOR 5
> +#define UD_VECTOR 6
> +#define NM_VECTOR 7
> +#define DF_VECTOR 8
> +#define TS_VECTOR 10
> +#define NP_VECTOR 11
> +#define SS_VECTOR 12
> +#define GP_VECTOR 13
> +#define PF_VECTOR 14
> +#define MF_VECTOR 16
> +#define MC_VECTOR 18

This is not a kvm ABI, but an x86 architecture constants.  It should be
put into an existing x86 header.

> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index f2b83bc..cdf5674 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -1,6 +1,135 @@
>  #ifndef __SVM_H
>  #define __SVM_H
>  
> +
> +#ifdef __KERNEL__
> +

The entire file can be exported; nothing in there is implementation
specific.

> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 74fcb96..61e04e9 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> +
> +#ifdef __KERNEL__
> +

Ditto.


-- 
error compiling committee.c: too many arguments to function
