Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0GROrr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 10:47:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab0GROrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 10:47:43 -0400
Message-ID: <4C43140E.4070206@redhat.com>
Date: Sun, 18 Jul 2010 17:47:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/18] Warn about unstable TSC
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-6-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-6-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 05:25 AM, Zachary Amsden wrote:
> If creating an SMP guest with unstable host TSC, issue a warning
>
> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
> ---
>   arch/x86/kvm/x86.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2d5b97a..36ef649 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5449,6 +5449,10 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
>   struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
>   						unsigned int id)
>   {
> +	if (check_tsc_unstable()&&  id != 0)
> +		printk_once(KERN_WARNING
> +		"kvm: SMP vm created on host with unstable TSC; "
> +		"guest TSC will not be reliable\n");
>   	return kvm_x86_ops->vcpu_create(kvm, id);
>   }
>
>    

'id' check not accurate (you can have a uniprocessor guest with id = 
1).  Better check online_vcpus.



-- 
error compiling committee.c: too many arguments to function

