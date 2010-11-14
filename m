Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab0KNKqn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 05:46:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab0KNKqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 05:46:42 -0500
Message-ID: <4CDFBE00.2000802@redhat.com>
Date: Sun, 14 Nov 2010 12:46:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: MMU: retry #PF for softmmu
References: <4CDCE2B0.7000601@cn.fujitsu.com> <4CDCE3C2.9030107@cn.fujitsu.com>
In-Reply-To: <4CDCE3C2.9030107@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 08:50 AM, Xiao Guangrong wrote:
> Retry #PF for softmmu only when the current vcpu has the same
> root shadow page as the time when #PF occurs. it means they
> have same paging environment
>

The process could have been killed and replaced by another using the 
same cr3.  Or we may be running a guest that uses the same cr3 for all 
processes.  Or another thread may have mmap()ed something else over the 
same address.  So I think this is incorrect.

Meanwhile, I applied patches 1-4.

-- 
error compiling committee.c: too many arguments to function

