Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0D0Nlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:41:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893Ab0D0Nlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:41:46 -0400
Date: Tue, 27 Apr 2010 10:40:13 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH 6/6] don't compute pvclock adjustments if we trust the tsc
Message-ID: <20100427134013.GE18410@amt.cnet>
References: <1272303988-21929-1-git-send-email-glommer@redhat.com>
 <1272303988-21929-2-git-send-email-glommer@redhat.com>
 <1272303988-21929-3-git-send-email-glommer@redhat.com>
 <1272303988-21929-4-git-send-email-glommer@redhat.com>
 <1272303988-21929-5-git-send-email-glommer@redhat.com>
 <1272303988-21929-6-git-send-email-glommer@redhat.com>
 <1272303988-21929-7-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272303988-21929-7-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 01:46:28PM -0400, Glauber Costa wrote:
> If the HV told us we can fully trust the TSC, skip any
> correction
> 
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> ---
>  arch/x86/include/asm/kvm_para.h    |    5 +++++
>  arch/x86/include/asm/pvclock-abi.h |    1 +
>  arch/x86/kernel/kvmclock.c         |    3 +++
>  arch/x86/kernel/pvclock.c          |    4 ++++
>  4 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index f019f8c..615ebb1 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -21,6 +21,11 @@
>   */
>  #define KVM_FEATURE_CLOCKSOURCE2        3
>  
> +/* The last 8 bits are used to indicate how to interpret the flags field
> + * in pvclock structure. If no bits are set, all flags are ignored.
> + */
> +#define KVM_FEATURE_CLOCKSOURCE_STABLE_TSC	0xf8
> +
>  #define MSR_KVM_WALL_CLOCK  0x11
>  #define MSR_KVM_SYSTEM_TIME 0x12

Please drop this. Its not certain what is the best method to reduce
contention on the global variable. Whatever it is, can be done later.

