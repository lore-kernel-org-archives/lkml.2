Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab1FUScd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:32:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65064 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab1FUScb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:32:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wYTDA5WIjvw+TycWMfl5IwrmULib0LD0WDnvjVrOlGn+WXWprD7/FPHHk03B488vjx
         jykZ+aXSKzhZzM/oyM3Pla4gVTTRGUg04mElcgF+FwLBK3PO5ZHTWv4Tesk0Lp4X6gH9
         /q0qrlPDuajSTpctRp+nmauDmtivgCSKx+pno=
Date: Tue, 21 Jun 2011 22:32:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
Message-ID: <20110621183227.GG21641@sun>
References: <BANLkTi=zPq81nScodFcPxcLSrTGPNA1HWA@mail.gmail.com>
 <1308671933.26237.183.camel@twins>
 <BANLkTim-2p1DgV1XD_J2vH514aL_KuFaEQ@mail.gmail.com>
 <BANLkTikxWV8tjXrZnOrNnsw+nmsjGaxWbw@mail.gmail.com>
 <20110621164820.GC21641@sun>
 <BANLkTink5nOTqvqQYr4kx0fnBoOpoq7CiQ@mail.gmail.com>
 <20110621172319.GE21641@sun>
 <BANLkTikBsfcFfnmgdVQem15P9f2ooQBzeA@mail.gmail.com>
 <20110621175421.GF21641@sun>
 <BANLkTim8OdhTdaayHZAKSXWhmN0anEhieQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim8OdhTdaayHZAKSXWhmN0anEhieQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 08:06:54PM +0200, Stephane Eranian wrote:
...
> 
> If in arch/x86/kernel/cpu/perf_event.c I add a callback which
> checks:
> 
>    if (netburst_host) {
>        attr.type = PERF_TYPE_RAW
>        attr.config = 0x3c
>    } else {
>       attr.type = PERF_TYPE_HARDWARE
>       attr.config = PERF_COUNT_HW__CPU_CYCLES
>   }
> 
> I simply don't think PERF_COUNT_HW_NMI_WATCHDOG should
> ever be exposed to users.

yes, and peterz pointed it out as well, i agree of course.

> 

So, you mean to put it into x86_pmu_event_init, right? How would
we know if this event comes from watchdog.c or not? And what if
user wanted to pass _exactly_ this crazy values to RAW event but
I will threat it as a sign for nmi-watchdog event and will map
it internally to P4_EVENT_EXECUTION_EVENT?

Don't get me wrong, Stephane, this approach will work and it's
not a problem (actually I think I would put -1ULL into config
since it's kinda "icorrect" and can be treated as special one)
but I think it introduce more complexity, it should not be like
this.

Gimme some time, probably I invent something more convenient.

	Cyrill
