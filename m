Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab2IYXgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:36:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2702 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2IYXgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:36:23 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=GecNO-ZYI38A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=NrfBHxz3jJsA:10 a=HLZ1M-sqcVSAPRLMQWYA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348616180.22822.27.camel@gandalf.local.home>
Subject: Re: [PATCH v4 3/3] tracing: format non-nanosec times from tsc clock
 without a decimal point.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Tue, 25 Sep 2012 19:36:20 -0400
In-Reply-To: <CAJL_ekvRFSDkFMmTyKD1-RTE2J=ajTdhb0s5TKmbVVKLRzakmw@mail.gmail.com>
References: <CAJL_eks01XMbcXJ3+EXy16Jy3hpX0Ti-BA57vH3fvYWmKS8=9g@mail.gmail.com>
	 <1348606147-12899-1-git-send-email-dhsharp@google.com>
	 <1348609336.22822.26.camel@gandalf.local.home>
	 <CAJL_ekvRFSDkFMmTyKD1-RTE2J=ajTdhb0s5TKmbVVKLRzakmw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 15:29 -0700, David Sharp wrote:


> >> +             ret = trace_seq_printf(
> >> +                             s, "[%08llx] %ld.%03ldms (+%ld.%03ldms): ",
> >> +                             ns2usecs(iter->ts),
> >> +                             abs_msec, abs_usec,
> >> +                             rel_msec, rel_usec);
> >> +     } else if (verbose && !in_ns) {
> >> +             ret = trace_seq_printf(
> >> +                             s, "[%016llx] %lld (+%lld): ",
> >> +                             iter->ts, abs_ts, rel_ts);
> >> +     } else { /* !verbose */
> >> +             ret = trace_seq_printf(
> >> +                             s, " %4lld%s%c: ",
> >> +                             abs_ts,
> >> +                             in_ns ? "us" : "",
> >> +                             rel_ts > mark_thresh ? '!' :
> >> +                               rel_ts > 1 ? '+' : ' ');
> 
> I just noticed something about this: with x86-tsc clock, this will
> always print a '+'. Does it matter? Also, is the 200k cycle threshold
> for '!' okay? I guess the counter clock will always end up with rel_ts
> == 1, so marks should never appear.
> 

Actually, I'm thinking that counters should not add those annotations.
As it just doesn't make sense.

-- Steve


