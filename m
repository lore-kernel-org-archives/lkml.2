Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1K2KCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:02:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab1K2KCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:02:11 -0500
Message-ID: <4ED4AD9E.1010604@redhat.com>
Date: Tue, 29 Nov 2011 12:02:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Jason Baron <jbaron@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: MMU: audit: replace mmu audit tracepoint with
 jump-lable
References: <4ED3811F.1070101@linux.vnet.ibm.com> <4ED3815C.9060901@linux.vnet.ibm.com> <20111128223305.GB2519@redhat.com> <4ED457D0.3010400@linux.vnet.ibm.com>
In-Reply-To: <4ED457D0.3010400@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 05:56 AM, Xiao Guangrong wrote:
> Subject: [PATCH v2 2/5] KVM: MMU: audit: replace mmu audit tracepoint with jump-lable
>
> The tracepoint is only used to audit mmu code, it should not be exposed to
> user, let us replace it with jump-lable
>
>
>  static bool mmu_audit;
> +static struct jump_label_key mmu_audit_key;
> +
> +#define kvm_mmu_audit(vcpu, point)		\
> +	if (static_branch((&mmu_audit_key))) {	\
> +		__kvm_mmu_audit(vcpu, point);	\
> +	}
>
>


static inline function, please, and as an incremental against next. I'll
fold it to the parent patch.

-- 
error compiling committee.c: too many arguments to function

