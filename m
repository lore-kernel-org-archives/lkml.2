Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab1LBBPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:15:16 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:45260 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab1LBBPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:15:14 -0500
Message-ID: <4ED826CA.5030502@oss.ntt.co.jp>
Date: Fri, 02 Dec 2011 10:15:54 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: Veirfy memory slot only for readability
References: <1322768576-9242-1-git-send-email-levinsasha928@gmail.com>
In-Reply-To: <1322768576-9242-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/12/02 4:42), Sasha Levin wrote:
> It's enough for memory slot to be readable, as the comment above the check
> states.
> 
> A user should be able to create read-only memory slot.

I submitted the original patch like you to speed up page table walking,
a hot path in KVM, and Avi applied the patch with changing the VERIFY_READ
to VERIFY_WRITE:  on x86, both do the same check.  You can see that on the
commit.

After that, Xiao started to write with __xxx_user() based on this check IIRC.
So you should keep the code as is and change the comment if you like!

Thanks,
	Takuya

> 
> Cc: Avi Kivity<avi@redhat.com>
> Cc: Marcelo Tosatti<mtosatti@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Sasha Levin<levinsasha928@gmail.com>
> ---
>   virt/kvm/kvm_main.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e289486..b92883f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -727,7 +727,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   	/* We can read the guest memory with __xxx_user() later on. */
>   	if (user_alloc&&
>   	((mem->userspace_addr&  (PAGE_SIZE - 1)) ||
> -	     !access_ok(VERIFY_WRITE,
> +	     !access_ok(VERIFY_READ,
>   			(void __user *)(unsigned long)mem->userspace_addr,
>   			mem->memory_size)))
>   		goto out;

