Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1GHNMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 09:12:25 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:39590 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab1GHNMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 09:12:22 -0400
Date: Fri, 8 Jul 2011 17:12:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
Message-ID: <20110708131218.GE23657@sun>
References: <20110705114944.GT17941@sun>
 <20110705121421.GU17941@sun>
 <20110705131005.GA5843@elte.hu>
 <1309871841.3282.148.camel@twins>
 <20110705133105.GB5843@elte.hu>
 <1309876851.3282.235.camel@twins>
 <20110705145656.GA18116@elte.hu>
 <20110705152515.GE4060@sun>
 <20110708124906.GD4303@elte.hu>
 <20110708130147.GD23657@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708130147.GD23657@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 05:01:47PM +0400, Cyrill Gorcunov wrote:
...
> 
> Changing cpu-cycles to bus cycles will allow nmi-watchdog and
> perf top co-exsist but it means perf bus-cycles won't work anymore

oops, I forgot that they both using MSR_P4_FSB_ESCR0/1, so no, they won't work
together (ie nmi-watchdog and perf top won't work simultaneously). So lets
wait for test results, I hope they pass well and we finally isolate all this
crap inside p4 pmu code leaving all code around untouched ;)

> with active nmi-watchdog. So I think events aliases (again, if it
> work :) will be better for us, right?
> 

	Cyrill
