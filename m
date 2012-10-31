Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422844Ab2JaNae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:30:34 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58267 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2JaNaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:30:30 -0400
MIME-Version: 1.0
In-Reply-To: <87ip9r5gus.fsf@sejong.aot.lge.com>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	<1351523752-4215-8-git-send-email-eranian@google.com>
	<87ip9r5gus.fsf@sejong.aot.lge.com>
Date: Wed, 31 Oct 2012 14:30:29 +0100
Message-ID: <CABPqkBRqCOBoQc2s5ggmn5_4DrfJaTs0HBDCddW+AhYhJ1sRhQ@mail.gmail.com>
Subject: Re: [Patch v1 07/10] perf tools: add mem access sampling core support
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 6:51 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> On Mon, 29 Oct 2012 16:15:49 +0100, Stephane Eranian wrote:
>> This patch adds the sorting and histogram support
>> functions to enable profiling of memory accesses.
>>
>> The following sorting orders are added:
>>  - symbol_daddr: data address symbol (or raw address)
>>  - dso_daddr: data address shared object
>>  - cost: access cost
>>  - locked: access uses locked transaction
>>  - tlb : TLB access
>>  - mem : memory level of the access (L1, L2, L3, RAM, ...)
>>  - snoop: access snoop mode
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
> [snip]
>> +/* --sort daddr_sym */
>> +static int64_t
>> +sort__daddr_cmp(struct hist_entry *left, struct hist_entry *right)
>> +{
>> +     struct addr_map_symbol *l = &left->mem_info->daddr;
>> +     struct addr_map_symbol *r = &right->mem_info->daddr;
>> +
>> +     return (int64_t)(r->addr - l->addr);
>> +}
>
> Doesn't it need to compare symbol (start address) if any, before doing
> it with raw addresses?
>
Possibly but we can't get to data symbols at the moment due to limitations
in kernel + perf tool.
