Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab0GNF52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 01:57:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64966 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab0GNF51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 01:57:27 -0400
Message-ID: <4C3D50D7.9010207@cn.fujitsu.com>
Date: Wed, 14 Jul 2010 13:53:27 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 3/4] KVM: MMU: track dirty page in speculative path properly
References: <4C3C3518.7080505@cn.fujitsu.com> <4C3C35B7.50101@cn.fujitsu.com>
In-Reply-To: <4C3C35B7.50101@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Xiao Guangrong wrote:

>  
>  		spte = rmap_next(kvm, rmapp, NULL);
> @@ -1879,9 +1877,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  	 * whether the guest actually used the pte (in order to detect
>  	 * demand paging).
>  	 */
> -	spte = shadow_base_present_pte | shadow_dirty_mask;
> +	spte = shadow_base_present_pte;
>  	if (!speculative)
> -		spte |= shadow_accessed_mask;
> +		spte |= shadow_accessed_mask | shadow_dirty_mask;

It breaks read-only shadow page, i'll update it... please ignore this version...
