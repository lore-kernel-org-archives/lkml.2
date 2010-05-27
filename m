Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093Ab0E0Lyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:54:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab0E0Lyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:54:36 -0400
Message-ID: <4BFE5D78.5040204@redhat.com>
Date: Thu, 27 May 2010 14:54:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: MMU: fix relaxing permission
References: <4BFC8B0D.2060106@cn.fujitsu.com> <4BFC8B8C.7010402@cn.fujitsu.com> <4BFE4513.8090606@redhat.com> <4BFE50E2.60203@cn.fujitsu.com> <4BFE54F8.7030309@redhat.com>
In-Reply-To: <4BFE54F8.7030309@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 02:18 PM, Avi Kivity wrote:
>
>> And, i think use 'spte.w=1, spte.u=0' to emulate 'guest cr0.wp=0 and 
>> gpte.w=0'
>> is not a good way since it can completely stop user process access, 
>> but in this
>> case, user process is usually read and kernel lazily to write, just 
>> like vdso,
>> it will generate a lots of #PF
>
> As soon as the guest kernel stops writing we switch back to 
> gpte.w=gpte.u=1 and the guest can access it completely.  For the case 
> where both the kernel and userspace use interleaved access, you are 
> right, but I don't see a better way, do you?

To expand, we only set spte.w=1 on write faults.  So if the guest only 
reads the page, we'll instantiate an spte with u=1 and w=0.

-- 
error compiling committee.c: too many arguments to function

