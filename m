Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab2J2PoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:44:18 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35852 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2J2PoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:44:13 -0400
MIME-Version: 1.0
In-Reply-To: <1351525219.24721.38.camel@twins>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	<1351523752-4215-7-git-send-email-eranian@google.com>
	<1351525219.24721.38.camel@twins>
Date: Mon, 29 Oct 2012 16:44:12 +0100
Message-ID: <CABPqkBQiwJuZJkDbEE6MVtwjqzruJdpPT=yZdC_kokfRFZmqdg@mail.gmail.com>
Subject: Re: [Patch v1 06/10] perf/x86: add support for PEBS Precise Store
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 4:40 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-10-29 at 16:15 +0100, Stephane Eranian wrote:
>> -       if (fll) {
>> +       if (fll || fst) {
>>                 if (sample_type & PERF_SAMPLE_ADDR)
>>                         data.addr = pebs->dla;
>>
>> @@ -688,6 +731,8 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>>                 if (sample_type & PERF_SAMPLE_DSRC) {
>>                         if (fll)
>>                                 data.dsrc.val = load_latency_data(pebs->dse);
>> +                       else if (fst)
>> +                               data.dsrc.val = precise_store_data(pebs->dse);
>>                 }
>>         }
>>
>
> Ah, this is why I guess.. hrm.. ok, n/m then.

Yes, it is. But your proposal and my extension for Precise Store look good too.
