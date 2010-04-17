Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0DQSvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 14:51:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab0DQSvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 14:51:44 -0400
Message-ID: <4BCA033D.5040807@redhat.com>
Date: Sat, 17 Apr 2010 21:51:41 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] change msr numbers for kvmclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com> <1271356648-5108-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1271356648-5108-3-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 09:37 PM, Glauber Costa wrote:
> Avi pointed out a while ago that those MSRs falls into the pentium
> PMU range. So the idea here is to add new ones, and after a while,
> deprecate the old ones.
>
> Signed-off-by: Glauber Costa<glommer@redhat.com>
> ---
>   arch/x86/include/asm/kvm_para.h |    8 ++++++--
>   arch/x86/kvm/x86.c              |    7 ++++++-
>   2 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index ffae142..0cffb96 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -17,8 +17,12 @@
>   #define KVM_FEATURE_NOP_IO_DELAY	1
>   #define KVM_FEATURE_MMU_OP		2
>
> -#define MSR_KVM_WALL_CLOCK  0x11
> -#define MSR_KVM_SYSTEM_TIME 0x12
> +#define MSR_KVM_WALL_CLOCK_OLD  0x11
> +#define MSR_KVM_SYSTEM_TIME_OLD 0x12
> +
> +/* Custom MSRs falls in the range 0x4b564d00-0x4b564dff */
> +#define MSR_KVM_WALL_CLOCK  0x4b564d00
> +#define MSR_KVM_SYSTEM_TIME 0x4b564d01
>    

This is exposed to userspace.  Userspace that is compiled with the new 
headers, but runs on an old kernel, will break.

So you need to keep the old names, and define a new KVM_FEATURE for the 
new names.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

