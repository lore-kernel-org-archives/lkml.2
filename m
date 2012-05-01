Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab2EABEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 21:04:20 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:51423 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab2EABET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 21:04:19 -0400
Message-ID: <4F9F367F.8090603@linux.vnet.ibm.com>
Date: Tue, 01 May 2012 06:33:59 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
CC: peterz@infradead.org, mingo@elte.hu, jeremy@goop.org, mtosatti@redhat.com,
        kvm@vger.kernel.org, x86@kernel.org, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, avi@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v1 1/5] KVM Guest: Add VCPU running/pre-empted state
 for guest
References: <20120427161727.27082.43096.stgit@abhimanyu> <20120427162314.27082.13703.stgit@abhimanyu>
In-Reply-To: <20120427162314.27082.13703.stgit@abhimanyu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12050101-2674-0000-0000-0000043A3440
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 09:53 PM, Nikunj A. Dadhania wrote:
> The patch adds guest code for msr between guest and hypervisor. The
> msr will export the vcpu running/pre-empted information to the guest
> from host. This will enable guest to intelligently send ipi to running
> vcpus and set flag for pre-empted vcpus. This will prevent waiting for
> vcpus that are not running.
>
> Suggested-by: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Signed-off-by: Nikunj A. Dadhania<nikunj@linux.vnet.ibm.com>
> ---
>   arch/x86/include/asm/kvm_para.h |   10 ++++++++++
>   arch/x86/kernel/kvm.c           |   33 +++++++++++++++++++++++++++++++++
>   2 files changed, 43 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 77266d3..f57b5cc 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -24,6 +24,7 @@
>   #define KVM_FEATURE_ASYNC_PF		4
>   #define KVM_FEATURE_STEAL_TIME		5
>   #define KVM_FEATURE_PV_UNHALT		6
> +#define KVM_FEATURE_VCPU_STATE          7

I think you intended to use KVM_FEATURE_VCPU_STATE to address
guest/host compatibility issue so that host/guest does not break
when one of them run older kernel?

