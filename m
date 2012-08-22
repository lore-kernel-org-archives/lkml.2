Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab2HVMWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:22:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab2HVMWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:22:54 -0400
Message-ID: <5034CF14.5020909@redhat.com>
Date: Wed, 22 Aug 2012 15:22:44 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] kvm: Fix nonsense handling of compat ioctl
References: <20120820144330.6218.27112.stgit@localhost.localdomain>
In-Reply-To: <20120820144330.6218.27112.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 05:43 PM, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> KVM_SET_SIGNAL_MASK passed a NULL argument leaves the on stack signal
> sets uninitialized. It then passes them through to
> kvm_vcpu_ioctl_set_sigmask.
> 
> We should be passing a NULL in this case not translated garbage.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  virt/kvm/kvm_main.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a2e85af..e47a7ca 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1975,9 +1975,10 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
>  			if (copy_from_user(&csigset, sigmask_arg->sigset,
>  					   sizeof csigset))
>  				goto out;
> -		}
> -		sigset_from_compat(&sigset, &csigset);
> -		r = kvm_vcpu_ioctl_set_sigmask(vcpu, &sigset);
> +			sigset_from_compat(&sigset, &csigset);
> +			r = kvm_vcpu_ioctl_set_sigmask(vcpu, &sigset);
> +		} else
> +			kvm_vcpu_ioctl_set_sigmask(vcpu, NULL);
>  		break;
>  	}

Now r is uninitiali[sz]ed.


-- 
error compiling committee.c: too many arguments to function
