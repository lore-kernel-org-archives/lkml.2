Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2AJPnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 10:43:32 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54124 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756250Ab2AJPnb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 10:43:31 -0500
MIME-Version: 1.0
In-Reply-To: <4F0B9374.5010207@fb.com>
References: <1326127761-2723-1-git-send-email-eranian@google.com>
	<1326127761-2723-12-git-send-email-eranian@google.com>
	<4F0B9374.5010207@fb.com>
Date: Tue, 10 Jan 2012 16:43:29 +0100
Message-ID: <CABPqkBRXK7QH9hOaFkCGt0u0Cauf0HLz+oAt72BWs5yZU66wgw@mail.gmail.com>
Subject: Re: [PATCH 11/13] perf: add code to support PERF_SAMPLE_BRANCH_STACK (v3)
From: Stephane Eranian <eranian@google.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@infradead.org, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, ravitillo@lbl.gov, vweaver1@eecs.utk.edu
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 2:25 AM, Arun Sharma <asharma@fb.com> wrote:
> On 1/9/12 8:49 AM, Stephane Eranian wrote:
>>
>> From: Roberto Agostino Vitillo<ravitillo@lbl.gov>
>>
>> This patch adds:
>> - ability to parse samples with PERF_SAMPLE_BRANCH_STACK
>> - sort on branches
>> - build histograms on branches
>>
> [..]
>>
>>  static struct sort_dimension sort_dimensions[] = {
>> -       { .name = "pid",        .entry =&sort_thread,   },
>> -       { .name = "comm",       .entry =&sort_comm,     },
>> -       { .name = "dso",        .entry =&sort_dso,      },
>> -       { .name = "symbol",     .entry =&sort_sym,      },
>> -       { .name = "parent",     .entry =&sort_parent,   },
>> -       { .name = "cpu",        .entry =&sort_cpu,      },
>> +       { .name = "pid",        .entry =&sort_thread,                   },
>> +       { .name = "comm",       .entry =&sort_comm,                     },
>> +       { .name = "dso",        .entry =&sort_dso,                      },
>> +       { .name = "dso_from",   .entry =&sort_dso_from,.taken = true    },
>> +       { .name = "dso_to",     .entry =&sort_dso_to,   .taken = true   },
>> +       { .name = "symbol",     .entry =&sort_sym,                      },
>> +       { .name = "symbol_from",.entry =&sort_sym_from,.taken = true    },
>> +       { .name = "symbol_to",  .entry =&sort_sym_to,   .taken = true   },
>> +       { .name = "parent",     .entry =&sort_parent,                   },
>> +       { .name = "cpu",        .entry =&sort_cpu,                      },
>>
>> +       { .name = "mispredict", .entry =&sort_mispredict, },
>>  };
>
>
> The new sort dimensions don't seem to show up in perf report -h. Could you
> please update the help text?
>
Can do this with the understanding that those are only avail when you
use branch sampling.

> Also:
>
> # perf script -h
>
>    -f, --fields <str>    comma separated output fields prepend with 'type:'.
> Valid types: hw,sw,trace,raw. Fields:
> comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr
>
> You probably want to add a field here, so I could:
>
> perf record -b any_call,u -e cycles:u
> perf script -f event,branch_stack
>
> and examine raw (symbolized) samples like I can with
>
> perf record -g
> perf script -f event,ip,sym
>
Ok, I'll look into this. Looks like a useful command for automating processing.

>  -Arun
>
