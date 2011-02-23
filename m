Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab1BWJ2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:28:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142Ab1BWJ2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:28:18 -0500
Message-ID: <4D64D32A.9090804@redhat.com>
Date: Wed, 23 Feb 2011 11:28:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 7/7] KVM: MMU: cache guest page number to guest frame
 number
References: <4D636EF8.60800@cn.fujitsu.com> <4D6370E8.6080008@cn.fujitsu.com> <4D63C8F9.1020708@redhat.com> <4D646517.8030702@cn.fujitsu.com>
In-Reply-To: <4D646517.8030702@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 03:38 AM, Xiao Guangrong wrote:
> On 02/22/2011 10:32 PM, Avi Kivity wrote:
> >  On 02/22/2011 10:16 AM, Xiao Guangrong wrote:
> >>  Cache guest page number to guest frame number to avoid walk guest page table
> >>  frequently, the 'vtlb' idea is from Xen.
> >>
> >>  Note:
> >>  we can't use vtlb in ept guests since the guest tlb invalid operation is not
> >>  intercept(reload CR3, invlpg), also can't used in L2 nnpt guest for the same
> >>  reason, but we can used it to cache L1's npt page table.
> >>
> >
> >  I'm not so hot about introducing a new mechanism strictly for older hosts... EPT exists in three generations of Intel processors now (Sandy Bridge, Westmere, and Nehalem), and NPT is significantly older.
> >
>
> Um...so, do we should stop the new features for softmmu, only bug fix is welcome? :-)

No.  There is always a tradeoff between features and complexity.  What 
I'm saying is that I want to shift the tradeoff, for older processors, 
towards reducing complexity.  An improvement that is very simple, or 
gives very large gains, will be accepted.  A complex improvement that 
gives small gains may be rejected (but if it's for newer processors, it 
may be accepted).  It's a way for the maintainers to manage the ever 
growing complexity.

-- 
error compiling committee.c: too many arguments to function

