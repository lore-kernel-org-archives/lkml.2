Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab1JGHG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 03:06:56 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:39549 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab1JGHGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 03:06:54 -0400
X-AuditID: b753bd60-a1c87ba000000655-83-4e8ea50b389d
X-AuditID: b753bd60-a1c87ba000000655-83-4e8ea50b389d
Message-ID: <4E8EA505.5050701@hitachi.com>
Date: Fri, 07 Oct 2011 16:06:45 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, robert.richter@amd.com, ravitillo@lbl.gov,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
References: <1317912555-9559-1-git-send-email-eranian@google.com>  <1317912555-9559-8-git-send-email-eranian@google.com>  <20111006153229.GJ14482@one.firstfloor.org> <1317919424.29658.13.camel@twins>
In-Reply-To: <1317919424.29658.13.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/07 1:43), Peter Zijlstra wrote:
> On Thu, 2011-10-06 at 17:32 +0200, Andi Kleen wrote:
>>> +	kernel_insn_init(&insn, kaddr);
>>> +	insn_get_opcode(&insn);
>>
>> This makes me uncomfortable. AFAIK that's the first use of the opcode
>> decoder being used directly for user space. It has a quite large attack
>> surface. Who says it cannot be exploited?
> 
> You mean:
> arch/x86/kernel/cpu/perf_event_intel_ds.c:intel_pmu_pebs_fixup_ip()
> doesn't use the opcode decoder on user space code?
> 
> ISTR Masami telling me they ran fuzzers on it, feeding it bad
> instructions etc. But maybe he can tell more.

I've tested it by decoding userspace libraries and binaries.
It is also easy to test decoding with random binaries too :)
I'll try to do that.

Thanks,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
