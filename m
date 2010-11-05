Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925Ab0KEEUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 00:20:54 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:41745 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0KEEUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 00:20:51 -0400
Message-ID: <4CD3868C.6080804@oss.ntt.co.jp>
Date: Fri, 05 Nov 2010 13:22:36 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jiri Kosina <trivial@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        amd64-microcode@amd64.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 05/49] arch/x86: Use vzalloc
References: <alpine.DEB.2.00.1011031108260.11625@router.home> <9eb79212eddaa03ff3e7ddc88bc59b7564ea317c.1288925424.git.joe@perches.com>
In-Reply-To: <9eb79212eddaa03ff3e7ddc88bc59b7564ea317c.1288925424.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/11/05 12:07), Joe Perches wrote:

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2288ad8..624d4da 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3174,10 +3174,9 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
>   		spin_unlock(&kvm->mmu_lock);
> 
>   		r = -ENOMEM;
> -		dirty_bitmap = vmalloc(n);
> +		dirty_bitmap = vzalloc(n);

This vmalloc() does not exist already, see kvm.git.

  Takuya

>   		if (!dirty_bitmap)
>   			goto out;
> -		memset(dirty_bitmap, 0, n);
> 
>   		r = -ENOMEM;
>   		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
