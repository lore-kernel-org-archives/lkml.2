Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1BVOcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:32:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab1BVOcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:32:31 -0500
Message-ID: <4D63C8F9.1020708@redhat.com>
Date: Tue, 22 Feb 2011 16:32:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 7/7] KVM: MMU: cache guest page number to guest frame
 number
References: <4D636EF8.60800@cn.fujitsu.com> <4D6370E8.6080008@cn.fujitsu.com>
In-Reply-To: <4D6370E8.6080008@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 10:16 AM, Xiao Guangrong wrote:
> Cache guest page number to guest frame number to avoid walk guest page table
> frequently, the 'vtlb' idea is from Xen.
>
> Note:
> we can't use vtlb in ept guests since the guest tlb invalid operation is not
> intercept(reload CR3, invlpg), also can't used in L2 nnpt guest for the same
> reason, but we can used it to cache L1's npt page table.
>

I'm not so hot about introducing a new mechanism strictly for older 
hosts... EPT exists in three generations of Intel processors now (Sandy 
Bridge, Westmere, and Nehalem), and NPT is significantly older.

I'd rather make the guest page table walk faster.  I believe that things 
like get_user() can be significantly faster than copy_from_user() on 
older hosts, and a four-level page table walk shouldn't be that slow.

-- 
error compiling committee.c: too many arguments to function

