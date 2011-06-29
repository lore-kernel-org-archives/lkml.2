Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab1F2JYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:24:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1F2JX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:23:59 -0400
Message-ID: <4E0AEF29.7080706@redhat.com>
Date: Wed, 29 Jun 2011 12:23:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 0/22] KVM: optimize for MMIO handled
References: <4E01FBC9.3020009@cn.fujitsu.com>
In-Reply-To: <4E01FBC9.3020009@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 05:27 PM, Xiao Guangrong wrote:
> In this version, we fix the bugs in the v1:
> - fix broken read emulation spans a page boundary
> - fix invalid spte point is got if we walk shadow page table
>    out of the mmu lock
>
> And, we also introduce some rules to modify spte in this version,
> then it does not need to atomically clear/set spte on x86_32 host
> anymore, the performance report of x86_32 host is in the later section
>
> Avi,
>
> I have sampled the operation of lockless shadow page walking as below steps:
> - mark walk_shadow_page_get_mmio_spte as 'noinline'
> - do the netperf test, the client is on the guest(NIC is e1000) and the server
>    is on the host, it can generate large press of mmio access
> - using perf to sample it, and the result of 'perf report' is attached
>
> The ratio of walk_shadow_page_get_mmio_spte is 0.09%, the ratio of handle_ept_misconfig
> is 0.11%, the ratio of handle_mmio_page_fault_common is 0.07%
>
> I think it is acceptable, your opinion?
>

Yes.

The patchset scares me, but it is nice work!  Good optimization and good 
clean up.

-- 
error compiling committee.c: too many arguments to function

