Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1CJHBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 02:01:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab1CJHBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 02:01:31 -0500
Message-ID: <4D787747.7080207@redhat.com>
Date: Thu, 10 Mar 2011 02:01:27 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: Re: [PATCHv2] fix regression caused by	e48672fa25e879f7ae21785c7efd187738139593
References: <20110307101827.GA1762@pcnci.linuxbox.cz> <4D768A62.3050903@redhat.com> <20110309193003.GB1762@pcnci.linuxbox.cz> <4D77F149.8020906@redhat.com> <20110309223651.GC1762@pcnci.linuxbox.cz>
In-Reply-To: <20110309223651.GC1762@pcnci.linuxbox.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 05:36 PM, Nikola Ciprich wrote:
> commit 387b9f97750444728962b236987fbe8ee8cc4f8c moved kvm_request_guest_time_update(vcpu),
> breaking 32bit SMP guests using kvm-clock. Fix this by moving (new) clock update function
> to proper place.
>
> Signed-off-by: Nikola Ciprich<nikola.ciprich@linuxbox.cz>
> ---
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4c27144..ba3f76f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2101,8 +2101,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   		if (check_tsc_unstable()) {
>   			kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
>   			vcpu->arch.tsc_catchup = 1;
> -			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>   		}
> +		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>   		if (vcpu->cpu != cpu)
>   			kvm_migrate_timers(vcpu);
>   		vcpu->cpu = cpu;
>
>    
ACK
