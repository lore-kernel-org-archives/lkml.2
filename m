Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab1CHT6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:58:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891Ab1CHT6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:58:31 -0500
Message-ID: <4D768A62.3050903@redhat.com>
Date: Tue, 08 Mar 2011 14:58:26 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: Re: [PATCH] add missing guest clock update removed by	e48672fa25e879f7ae21785c7efd187738139593
References: <20110307101827.GA1762@pcnci.linuxbox.cz>
In-Reply-To: <20110307101827.GA1762@pcnci.linuxbox.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2011 05:18 AM, Nikola Ciprich wrote:
> e48672fa25e879f7ae21785c7efd187738139593 removed kvm_request_guest_time_update(vcpu);
> this breaks 32bit SMP guests using virtio-clock.
> thus add unconditional call to kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu) to fix the
> problem.
>
> Signed-off-by: Nikola Ciprich<nikola.ciprich@linuxbox.cz>
> ---
>   arch/x86/kvm/x86.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bcc0efc..4c27144 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2091,6 +2091,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	}
>
>   	kvm_x86_ops->vcpu_load(vcpu, cpu);
> +	kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>   	if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
>   		/* Make sure TSC doesn't go backwards */
>   		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
>
>
>    

Can you try moving the kvm_make_request() inside the if conditional and 
see if it that also fixes it?
