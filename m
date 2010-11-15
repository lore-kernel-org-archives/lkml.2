Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab0KOJ7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:59:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab0KOJ7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:59:17 -0500
Message-ID: <4CE1046F.8060100@redhat.com>
Date: Mon, 15 Nov 2010 11:59:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: MMU: retry #PF for softmmu
References: <4CDCE2B0.7000601@cn.fujitsu.com> <4CDCE3C2.9030107@cn.fujitsu.com> <4CDFBE00.2000802@redhat.com> <4CE0C45C.809@cn.fujitsu.com> <4CE0FDBC.20505@redhat.com> <4CE1038D.9020403@cn.fujitsu.com>
In-Reply-To: <4CE1038D.9020403@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 11:55 AM, Xiao Guangrong wrote:
> >>  >   Or another thread may have mmap()ed something else over the
> >>  >   same address.
> >>
> >>  The mmap virtual address is also visible for other threads since the
> >>  threads
> >>  have the same page table, so i think this case is the same as above?
> >
> >  Again, don't we install the wrong spte in this case?
> >
>
> I think it doesn't corrupts spte since we will walk guest page table again
> and map it to shadow pages when we retry #PF.

Well, you're right, we don't use any gfn/pfn info from the async page fault.

However, we're still not modelling the cpu accurately.  For example we 
will set dirty and accessed bits, or inject a page fault if the gpte 
turns out to be not present.

-- 
error compiling committee.c: too many arguments to function

