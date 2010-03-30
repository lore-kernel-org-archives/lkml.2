Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0C3Ncz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 09:32:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497Ab0C3Ncy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 09:32:54 -0400
Message-ID: <4BB1FD69.6040409@redhat.com>
Date: Tue, 30 Mar 2010 16:32:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <mtosatti@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] KVM MMU: thinking of shadow page cache
References: <4BB15B1A.7090901@cn.fujitsu.com>
In-Reply-To: <4BB15B1A.7090901@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 04:59 AM, Xiao Guangrong wrote:
> When we cached shadow page tables, one guest page table may have
> many shadow pages, take below case for example:
>
>   (RO+U) --->  |------| __     |------|
>   (W+U ) --->  |  GP1 |   |    |  GP2 |
>   (W+P ) --->  |------|   |-->  |------|
>
> There have 3 kinds of permission mapping to GP1, so we should
> allocate 3 shadow pages for GP1 and 3 shadow pages for GP2.
> And it has 3 class permissions(R/W, U/S, X/NX) in x86's architecture,
> for the worst case, we should allocate 2^3 pages for every paging
> mapping level.
>
> This waste is caused by that we only set the permission bits in PTE,
> not in the middle mapping level.
>
> So, i think we can mapping guest page table's permission into cache
> shadow page table, then it can be shared between many shadow page tables
> if their map to the same gust physics address. For above case, we only need 2
> pages.
>
> Any comments?
>    

We've considered this in the past, it makes sense.  The big question is 
whether any guests actually map the same page table through PDEs with 
different permissions (mapping the same page table through multiple PDEs 
is very common, but always with the same permissions).  Do you know of 
any such guest?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

