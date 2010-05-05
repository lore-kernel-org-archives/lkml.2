Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737Ab0EEI2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 04:28:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155Ab0EEI2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 04:28:13 -0400
Message-ID: <4BE12C1B.8070409@redhat.com>
Date: Wed, 05 May 2010 11:28:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zamsden@redhat.com
Subject: Re: [PATCH v2 6/7] don't compute pvclock adjustments if we trust
 the tsc
References: <1272901927-829-1-git-send-email-glommer@redhat.com> <1272901927-829-2-git-send-email-glommer@redhat.com> <1272901927-829-3-git-send-email-glommer@redhat.com> <1272901927-829-4-git-send-email-glommer@redhat.com> <1272901927-829-5-git-send-email-glommer@redhat.com> <1272901927-829-6-git-send-email-glommer@redhat.com> <1272901927-829-7-git-send-email-glommer@redhat.com>
In-Reply-To: <1272901927-829-7-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 06:52 PM, Glauber Costa wrote:
> If the HV told us we can fully trust the TSC, skip any
> correction
>
>    

> Signed-off-by: Glauber Costa<glommer@redhat.com>
> ---
>   arch/x86/include/asm/kvm_para.h    |    5 +++++
>   arch/x86/include/asm/pvclock-abi.h |    1 +
>   arch/x86/kernel/kvmclock.c         |    3 +++
>   arch/x86/kernel/pvclock.c          |    4 ++++
>   4 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index f019f8c..6f1b878 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -21,6 +21,11 @@
>    */
>   #define KVM_FEATURE_CLOCKSOURCE2        3
>
> +/* The last 8 bits are used to indicate how to interpret the flags field
> + * in pvclock structure. If no bits are set, all flags are ignored.
> + */
> +#define KVM_FEATURE_CLOCKSOURCE_STABLE_TSC	24
>    

This needs documentation (in cpuid.txt).  The flag doesn't mean the TSC 
is stable, rather it means the pvclock tsc stable bit is valid.


-- 
error compiling committee.c: too many arguments to function

