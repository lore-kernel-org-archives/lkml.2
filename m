Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab1CFMcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:32:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab1CFMct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:32:49 -0500
Message-ID: <4D737EEB.2000104@redhat.com>
Date: Sun, 06 Mar 2011 14:32:43 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 10/10] KVM: cleanup memslot_id function
References: <4D70C569.1030107@cn.fujitsu.com> <4D70C6AF.1010406@cn.fujitsu.com>
In-Reply-To: <4D70C6AF.1010406@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 01:02 PM, Xiao Guangrong wrote:
> We can get memslot id from memslot->id directly
>
>
> @@ -388,6 +387,12 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>   int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
>   int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
>   struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
> +
> +static inline int memslot_id(struct kvm *kvm, gfn_t gfn)
> +{
> +	return gfn_to_memslot(kvm, gfn)->id;
> +}
> +
>   int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
>   unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn);
>   void mark_page_dirty(struct kvm *kvm, gfn_t gfn);

Please put the function near the other inlines.

-- 
error compiling committee.c: too many arguments to function

