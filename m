Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1CGIzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:55:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab1CGIzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:55:21 -0500
Message-ID: <4D749D70.1020106@redhat.com>
Date: Mon, 07 Mar 2011 10:55:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/10] KVM: MMU: fix kvm_mmu_get_spte_hierarchy
References: <4D70C569.1030107@cn.fujitsu.com> <4D70C597.4070105@cn.fujitsu.com> <20110305164805.GB4607@amt.cnet> <4D744BA5.5020607@cn.fujitsu.com>
In-Reply-To: <4D744BA5.5020607@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2011 05:06 AM, Xiao Guangrong wrote:
> We can get the large mapping pte in the loop:
>
> static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
> {
> 	if (iterator->level<  PT_PAGE_TABLE_LEVEL)
> 		return false;
>
> 	if (iterator->level == PT_PAGE_TABLE_LEVEL)


> 		if (is_large_pte(*iterator->sptep))
> 			return false;
>
> 	......
> }
>
> if level>  1 and pte.pse is set, it will return true.
>
> And, i think this judgment is useless:
> 	if (iterator->level == PT_PAGE_TABLE_LEVEL)
> 		if (is_large_pte(*iterator->sptep))
> 			return false;
> since if level = 1, the pte bit7 is PAT.

Right, the logic is inverted.  I'll fix it up.

-- 
error compiling committee.c: too many arguments to function

