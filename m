Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465Ab2C2NHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:07:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab2C2NHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:07:43 -0400
Message-ID: <4F745E7D.5080102@redhat.com>
Date: Thu, 29 Mar 2012 15:07:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 04/13] KVM: MMU: introduce FNAME(get_sp_gpa)
References: <4F742951.7080003@linux.vnet.ibm.com> <4F7429E7.3010801@linux.vnet.ibm.com>
In-Reply-To: <4F7429E7.3010801@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 11:22 AM, Xiao Guangrong wrote:
> It can calculate the base gpa of the specified shadow page on any level,
> let it instead of FNAME(get_level1_sp_gpa)
>
>
> +static gpa_t FNAME(get_sp_gpa)(struct kvm_mmu_page *sp)
> +{

Maybe worth adding a pte index and calling it get_spte_gpa(), depends on
the next patches I guess.

> +	int offset, shift;
> +
> +	shift = PAGE_SHIFT - (PT_LEVEL_BITS - PT64_LEVEL_BITS) * sp->role.level;
> +	offset = sp->role.quadrant << shift;

if you add '& ~PAGE_MASK' the compiler may be smart enough to drop the
whole thing for 64-bit ptes.

> +
> +	return gfn_to_gpa(sp->gfn) + offset;
> +}
> +
>  /*
>   * Page fault handler.  There are several causes for a page fault:
>   *   - there is no shadow pte for the guest pte
> @@ -659,18 +669,6 @@ out_unlock:
>  	return 0;
>

-- 
error compiling committee.c: too many arguments to function

