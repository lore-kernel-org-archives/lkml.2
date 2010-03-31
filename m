Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381Ab0CaNnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 09:43:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34761 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349Ab0CaNnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 09:43:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=eHJz3yMAGAGdbTgm7fJLWKwLHpTcHnLIs6rkYnKI28xEiEjX5V79DtM69ZvCNYQQFw
         rst6F/ji+FBNqcTBvNPG40SsBSTzKLcs86WI71PG1522pSAIXsIHbDFooPHigNuQOiwd
         C7meRglA8niz/PmkNgK+ZvMXcF9rki/9XXfjE=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <4BB28537.2060003@linux.vnet.ibm.com>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
	 <d3f22a1003290213x7d7904an59d50eb6a8616133@mail.gmail.com>
	 <1269934931.8575.6.camel@minggr.sh.intel.com>
	 <4BB22BB0.8030208@linux.vnet.ibm.com>
	 <u2h7c86c4471003301428v9189ccbesec68ee149dfe9f@mail.gmail.com>
	 <4BB28537.2060003@linux.vnet.ibm.com>
Date: Wed, 31 Mar 2010 15:43:30 +0200
Message-ID: <y2y7c86c4471003310643u227256b2t62219a4ac2393e35@mail.gmail.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: stephane eranian <eranian@googlemail.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 1:11 AM, Corey Ashford
<cjashfor@linux.vnet.ibm.com> wrote:
> On 3/30/2010 2:28 PM, stephane eranian wrote:
>>
>> On Tue, Mar 30, 2010 at 6:49 PM, Corey Ashford
>> <cjashfor@linux.vnet.ibm.com>  wrote:
>>>
>>> 4) How do we choose a CPU to do the housekeeping work for a particular
>>> nest
>>> PMU.  Peter thought that user space should still specify the it via
>>> open_perf_event() cpu parameter, but there's also an argument to be made
>>> for
>>> the kernel choosing the best CPU to handle the job, or at least make it
>>> optional for the user to choose the CPU.
>>>
>> One of the housekeeping task is to handle uncore PMU interrupts, for
>> instance.
>> That is not a trivial task given that events are managed independently and
>> that you could be monitoring per-thread or system-wide. It may be that
>> some uncore PMU can only interrupt one core. Intel Nehalem can interrupt
>> many at once.
>
> That's a good point, and I think it's unreasonable to expect that the user
> knows exactly how the interrupts are connected from the uncore/nest PMU to
> which CPU(s).
>
> Perhaps one way around this would be to return an error if the chosen CPU
> wasn't fully capable of performing the housekeeping functions for the
> requested PMU. But this certainly isn't ideal, because relying on this
> mechanism would require that the user (or user tool) figure out which CPU is
> fully capable by trial-and-error.
>

I think users should not have to worry about all of this. It is also
fine to restrict
any uncore monitoring to system-wide mode, i.e., not per-thread. But I have
also seen people requesting just that hoping they could draw correlations
between core and uncore events in one run. I think this is less critical though.

In the specific case of CPU-uncore (e.g., Nehalem uncore), you could simply
identify the uncore PMU with the CPU. For anything else, you would definitively
need the file descriptor. The more uniform approach would have been to use
the file descriptor all along, except for per-thread. But that's fine, I think.
