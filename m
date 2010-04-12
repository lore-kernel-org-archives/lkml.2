Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0DLIgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:36:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab0DLIgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:36:44 -0400
Message-ID: <4BC2DB95.70704@redhat.com>
Date: Mon, 12 Apr 2010 11:36:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] KVM MMU: reduce kvm_mmu_page size
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D43A.5020003@cn.fujitsu.com>
In-Reply-To: <4BC2D43A.5020003@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 11:05 AM, Xiao Guangrong wrote:
> 'multimapped' and 'unsync' in 'struct kvm_mmu_page' are just indication
> field, we can use flag bits instand of them
>
> @@ -202,9 +202,10 @@ struct kvm_mmu_page {
>   	 * in this shadow page.
>   	 */
>   	DECLARE_BITMAP(slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
> -	int multimapped;         /* More than one parent_pte? */
>   	int root_count;          /* Currently serving as active root */
> -	bool unsync;
> +	#define MMU_PAGE_MULTIMAPPED 0x1        /* More than one parent_pte? */
> +	#define MMU_PAGE_UNSYNC 0x2
> +	unsigned int flags;
>   	unsigned int unsync_children;
>   	union {
>    

Please just use bool for multimapped.  If we grow more than 4 flags, we 
can use 'bool flag : 1;' to reduce space while retaining readability.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

