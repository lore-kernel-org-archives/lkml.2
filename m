Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab0KEEXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 00:23:15 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:41809 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab0KEEXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 00:23:12 -0400
Message-ID: <4CD38723.5000303@oss.ntt.co.jp>
Date: Fri, 05 Nov 2010 13:25:07 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jiri Kosina <trivial@kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 49/49] virt/kvm/kvm_main.c: Use vzalloc
References: <alpine.DEB.2.00.1011031108260.11625@router.home> <e57b4ed114851004b2839cb449937fc657634362.1288925425.git.joe@perches.com>
In-Reply-To: <e57b4ed114851004b2839cb449937fc657634362.1288925425.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/11/05 12:08), Joe Perches wrote:
> Signed-off-by: Joe Perches<joe@perches.com>
> ---
>   virt/kvm/kvm_main.c |   13 +++----------
>   1 files changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c

Already changed to vzalloc(), see kvm.git.

Takuya


> index 5225052..c2a08e6e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -604,13 +604,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   	/* Allocate if a slot is being created */
>   #ifndef CONFIG_S390
>   	if (npages&&  !new.rmap) {
> -		new.rmap = vmalloc(npages * sizeof(*new.rmap));
> -
> +		new.rmap = vzalloc(npages * sizeof(*new.rmap));
>   		if (!new.rmap)
>   			goto out_free;
> 
> -		memset(new.rmap, 0, npages * sizeof(*new.rmap));
> -
>   		new.user_alloc = user_alloc;
>   		new.userspace_addr = mem->userspace_addr;
>   	}
> @@ -633,14 +630,11 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   			>>  KVM_HPAGE_GFN_SHIFT(level));
>   		lpages -= base_gfn>>  KVM_HPAGE_GFN_SHIFT(level);
> 
> -		new.lpage_info[i] = vmalloc(lpages * sizeof(*new.lpage_info[i]));
> +		new.lpage_info[i] = vzalloc(lpages * sizeof(*new.lpage_info[i]));
> 
>   		if (!new.lpage_info[i])
>   			goto out_free;
> 
> -		memset(new.lpage_info[i], 0,
> -		       lpages * sizeof(*new.lpage_info[i]));
> -
>   		if (base_gfn&  (KVM_PAGES_PER_HPAGE(level) - 1))
>   			new.lpage_info[i][0].write_count = 1;
>   		if ((base_gfn+npages)&  (KVM_PAGES_PER_HPAGE(level) - 1))
> @@ -663,10 +657,9 @@ skip_lpage:
>   	if ((new.flags&  KVM_MEM_LOG_DIRTY_PAGES)&&  !new.dirty_bitmap) {
>   		unsigned long dirty_bytes = kvm_dirty_bitmap_bytes(&new);
> 
> -		new.dirty_bitmap = vmalloc(dirty_bytes);
> +		new.dirty_bitmap = vzalloc(dirty_bytes);
>   		if (!new.dirty_bitmap)
>   			goto out_free;
> -		memset(new.dirty_bitmap, 0, dirty_bytes);
>   		/* destroy any largepage mappings for dirty tracking */
>   		if (old.npages)
>   			flush_shadow = 1;

