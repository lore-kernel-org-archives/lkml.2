Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863Ab2EXRHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:07:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44482 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933807Ab2EXRHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:07:35 -0400
Message-ID: <4FBE6AD2.6050501@gmail.com>
Date: Thu, 24 May 2012 11:07:30 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: Re: perf, x86: only do lbr init if bts is available
References: <4FBE5FA6.5050802@gmail.com> <CABPqkBT7dKa3P2hk=_pismGdPHuseWMbCKhUzz1sQNDemb133A@mail.gmail.com> <4FBE64D0.7040507@gmail.com>
In-Reply-To: <4FBE64D0.7040507@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/12 10:41 AM, David Ahern wrote:
> On 5/24/12 10:35 AM, Stephane Eranian wrote:
>> Where is the wrmsr coming from? What we need to do is ensure that LBR
>> is not
>> touched if we don't actually use it.
>
> e.g., intel_pmu_lbr_init_nhm sets up lbr_nr, lbr_from, lbr_to and from,
> etc. Fhat I can tell intel_pmu_lbr_reset() gets invoked some where
> during the VM boot; I haven't traced how/when yet.

[    0.012998]  [<c04220ca>] intel_pmu_lbr_reset+0x2a/0xa0
[    0.012998]  [<c0423beb>] intel_pmu_cpu_starting+0x3b/0x100
[    0.012998]  [<c0424bd0>] ? allocate_shared_regs+0x20/0x50
[    0.012998]  [<c0932714>] x86_pmu_notifier+0xb3/0xc0
[    0.012998]  [<c0bed54c>] init_hw_perf_events+0x42c/0x456
[    0.012998]  [<c0403034>] do_one_initcall+0x34/0x170
[    0.012998]  [<c0bf2388>] ? native_smp_prepare_cpus+0x2b7/0x2f2
[    0.012998]  [<c0bed120>] ? check_bugs+0xf9/0xf9
[    0.012998]  [<c0be4833>] kernel_init+0x77/0x1a4
[    0.012998]  [<c0be47bc>] ? start_kernel+0x36d/0x36d
[    0.012998]  [<c094af7e>] kernel_thread_helper+0x6/0x10

