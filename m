Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0H0RPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:15:36 -0400
Received: from thoth.sbs.de ([192.35.17.2]:22951 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab0H0RPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:15:32 -0400
Message-ID: <4C77E89E.3040106@siemens.com>
Date: Fri, 27 Aug 2010 18:32:30 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 13/35] Perform hardware_enable in CPU_STARTING
 callback
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-14-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-14-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> The CPU_STARTING callback was added upstream with the intention
> of being used for KVM, specifically for the hardware enablement
> that must be done before we can run in hardware virt.  It had
> bugs on the x86_64 architecture at the time, where it was called
> after CPU_ONLINE.  The arches have since merged and the bug is
> gone.

What bugs are you referring to, or since which kernel version is
CPU_STARTING usable for KVM? I need to encode this into kvm-kmod.

Thanks,
Jan

> 
> It might be noted other features should probably start making
> use of this callback; microcode updates in particular which
> might be fixing important erratums would be best applied before
> beginning to run user tasks.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
> ---
>  virt/kvm/kvm_main.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b78b794..d4853a5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1958,10 +1958,10 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
>  		       cpu);
>  		hardware_disable(NULL);
>  		break;
> -	case CPU_ONLINE:
> +	case CPU_STARTING:
>  		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
>  		       cpu);
> -		smp_call_function_single(cpu, hardware_enable, NULL, 1);
> +		hardware_enable(NULL);
>  		break;
>  	}
>  	return NOTIFY_OK;
> @@ -2096,7 +2096,6 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>  
>  static struct notifier_block kvm_cpu_notifier = {
>  	.notifier_call = kvm_cpu_hotplug,
> -	.priority = 20, /* must be > scheduler priority */
>  };
>  
>  static int vm_stat_get(void *_offset, u64 *val)

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
