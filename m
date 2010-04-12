Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab0DLK0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 06:26:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab0DLK0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 06:26:05 -0400
Message-ID: <4BC2F536.70808@redhat.com>
Date: Mon, 12 Apr 2010 13:25:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] KVM MMU: fix kvm_mmu_zap_page() and its calling path
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D345.100@cn.fujitsu.com> <4BC2D8D6.6030306@redhat.com> <4BC2DFA0.6000609@cn.fujitsu.com> <4BC2E2FF.9020005@redhat.com> <4BC2E654.7050002@cn.fujitsu.com>
In-Reply-To: <4BC2E654.7050002@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 12:22 PM, Xiao Guangrong wrote:
> Hi Avi,
>
> Avi Kivity wrote:
>
>    
>> hlist_for_each_entry_safe() is supposed to be be safe against removal of
>> the element that is pointed to by the iteration cursor.
>>      
> If we destroyed the next point, hlist_for_each_entry_safe() is unsafe.
>
> List hlist_for_each_entry_safe()'s code:
>
> |#define hlist_for_each_entry_safe(tpos, pos, n, head, member) 		 \
> |	for (pos = (head)->first;					 \
> |	     pos&&  ({ n = pos->next; 1; })&&  				\
> |		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
> |	     pos = n)
>
> if n is destroyed:
> 'pos = n, n = pos->next'
> then it access n again, it's unsafe/illegal for us.
>    

But kvm_mmu_zap_page() will only destroy sp == tpos == pos; n points at 
pos->next already, so it's safe.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

