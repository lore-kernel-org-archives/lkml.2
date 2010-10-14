Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0JNLGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 07:06:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4285 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab0JNLGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 07:06:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mIzT4wIl1fYZM/pmXJ5yaZWOoPL5Z9jk1fquniW747fImVb07O6+V72bCFtryJDB1B
         JoK3mw6pS4W9696p5Rqw==
MIME-Version: 1.0
In-Reply-To: <1286954453.29097.58.camel@twins>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
	<1286946421-32202-3-git-send-regression-fweisbec@gmail.com>
	<1286954453.29097.58.camel@twins>
Date: Thu, 14 Oct 2010 13:06:30 +0200
Message-ID: <AANLkTinhGrdGyLaOGtXPktQM2uQ_0M9XQ1GjtBAYf+LY@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] perf: Add ability to dump user regs
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



On Wed, Oct 13, 2010 at 9:20 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-10-13 at 07:06 +0200, Frederic Weisbecker wrote:
>> Add new PERF_SAMPLE_UREGS to perf sample type. This will dump the
>> user space context as it was before the user entered the kernel for
>> whatever reason.
>>
>> This is going to be useful to bring Dwarf CFI based stack unwinding
>> on top of samples.
>
> This doesn't address any of the issues that were raised previously.
>
> There's a reason we don't have PERF_SAMPLE_*REGS like things.
>
We definitively need to find a solution to this problem. It is important
to export this kind of information to users when using PEBS, for instance

What is exported depends on what is monitored and not just the ABI
of the kernel. On a 64-bit kernel, you may capture samples from
i386 or x86_64. Somehow the record needs to be self describing.

What about something like:
struct  {
      int type; /* 32-bit, 64-bit */
      int nr;    /* number of regs */
      struct {
          int reg_name; /* taken from an enum with all possible regs */
          u64 reg_value;
      } [0]
};
