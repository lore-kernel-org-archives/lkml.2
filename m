Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab2IZAdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 20:33:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35760 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2IZAdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 20:33:06 -0400
MIME-Version: 1.0
In-Reply-To: <1348616180.22822.27.camel@gandalf.local.home>
References: <CAJL_eks01XMbcXJ3+EXy16Jy3hpX0Ti-BA57vH3fvYWmKS8=9g@mail.gmail.com>
 <1348606147-12899-1-git-send-email-dhsharp@google.com> <1348609336.22822.26.camel@gandalf.local.home>
 <CAJL_ekvRFSDkFMmTyKD1-RTE2J=ajTdhb0s5TKmbVVKLRzakmw@mail.gmail.com> <1348616180.22822.27.camel@gandalf.local.home>
From: David Sharp <dhsharp@google.com>
Date: Tue, 25 Sep 2012 17:32:43 -0700
Message-ID: <CAJL_eks59oRFh=ZNmdh1bP77FnCye0wuQW+-H-qU47R35yYZ9w@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] tracing: format non-nanosec times from tsc clock
 without a decimal point.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 4:36 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2012-09-25 at 15:29 -0700, David Sharp wrote:
>
>
>> >> +             ret = trace_seq_printf(
>> >> +                             s, "[%08llx] %ld.%03ldms (+%ld.%03ldms): ",
>> >> +                             ns2usecs(iter->ts),
>> >> +                             abs_msec, abs_usec,
>> >> +                             rel_msec, rel_usec);
>> >> +     } else if (verbose && !in_ns) {
>> >> +             ret = trace_seq_printf(
>> >> +                             s, "[%016llx] %lld (+%lld): ",
>> >> +                             iter->ts, abs_ts, rel_ts);
>> >> +     } else { /* !verbose */
>> >> +             ret = trace_seq_printf(
>> >> +                             s, " %4lld%s%c: ",
>> >> +                             abs_ts,
>> >> +                             in_ns ? "us" : "",
>> >> +                             rel_ts > mark_thresh ? '!' :
>> >> +                               rel_ts > 1 ? '+' : ' ');
>>
>> I just noticed something about this: with x86-tsc clock, this will
>> always print a '+'. Does it matter? Also, is the 200k cycle threshold
>> for '!' okay? I guess the counter clock will always end up with rel_ts
>> == 1, so marks should never appear.
>>
>
> Actually, I'm thinking that counters should not add those annotations.
> As it just doesn't make sense.

Right. But they won't appear anyway, since the delta will always be 1.

wait, by "counters" are you including TSC? Surely that makes sense,
since it is a measurement of time.

Eh... sorry I brought it up. I don't really want to change it. I never
use the latency tracer, so I mostly just don't want to break it.
