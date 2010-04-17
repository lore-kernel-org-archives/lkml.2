Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab0DQSXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 14:23:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab0DQSXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 14:23:46 -0400
Message-ID: <4BC9FC9A.6050807@redhat.com>
Date: Sat, 17 Apr 2010 21:23:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       kvm@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>,
       linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, tim.c.chen@intel.com,
       zhiteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V4 1/2] perf & kvm: Enhance perf to collect KVM guest
 os statistics from host side
References: <1271403275.2078.509.camel@ymzhang.sh.intel.com>
In-Reply-To: <1271403275.2078.509.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2010 10:34 AM, Zhang, Yanmin wrote:
> Below is the kernel patch to enable perf to collect guest os statistics.
>
> Joerg,
>
> Would you like to add support on svm? I don't know the exact point to trigger
> NMI to host with svm.
>
> See below code with vmx:
>
> +		kvm_before_handle_nmi(&vmx->vcpu);
>   		asm("int $2");
> +		kvm_after_handle_nmi(&vmx->vcpu);
>
> Signed-off-by: Zhang Yanmin<yanmin_zhang@linux.intel.com>
>    

Can you please split it further?

Patch 1 introduces perf_register_guest_info_callbacks() and related.  
Ingo can merge this into a branch in tip.git.
Patch 2 is just the kvm bits, I'll apply that after merging the branch 
with patch 1.
Patch 3 adds the tools/perf changes.

This way perf development can continue on tip.git, and kvm development 
can continue on kvm.git, without the code bases diverging and requiring 
a merge later.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

