Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1EXG6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:58:21 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:49232 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab1EXG6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:58:20 -0400
X-Greylist: delayed 1674 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 May 2011 02:58:20 EDT
Date: Tue, 24 May 2011 15:33:51 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: add missing void __user * cast to access_ok() call
Message-Id: <20110524153351.5eb98e74.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20110524055127.GA2460@osiris.boeblingen.de.ibm.com>
References: <20110524055127.GA2460@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed 3.1.0beta2 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011 07:51:27 +0200
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> fa3d315a "KVM: Validate userspace_addr of memslot when registered" introduced
> this new warning onn s390:
> 
> kvm_main.c: In function '__kvm_set_memory_region':
> kvm_main.c:654:7: warning: passing argument 1 of '__access_ok' makes pointer from integer without a cast
> arch/s390/include/asm/uaccess.h:53:19: note: expected 'const void *' but argument is of type '__u64'
> 
> Add the missing cast to get rid of it again...
> 

Looks good to me, thank you!

I should have checked s390's type checking...

  Takuya


> Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  virt/kvm/kvm_main.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -651,7 +651,8 @@ int __kvm_set_memory_region(struct kvm *
>  	/* We can read the guest memory with __xxx_user() later on. */
>  	if (user_alloc &&
>  	    ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
> -	     !access_ok(VERIFY_WRITE, mem->userspace_addr, mem->memory_size)))
> +	     !access_ok(VERIFY_WRITE, (void __user *)mem->userspace_addr,
> +			mem->memory_size)))
>  		goto out;
>  	if (mem->slot >= KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
>  		goto out;


-- 
Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
