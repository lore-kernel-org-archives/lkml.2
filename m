Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab2KPTei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:34:38 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54988 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab2KPTeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:34:37 -0500
Date: Fri, 16 Nov 2012 11:35:37 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, robert.richter@amd.com,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] perf/POWER7: Make event translations available in
 sysfs
Message-ID: <20121116193537.GA11800@us.ibm.com>
References: <20121107191818.GA16211@us.ibm.com>
 <20121107191927.GC16211@us.ibm.com>
 <20121114102534.GA2220@krava.brq.redhat.com>
 <20121114182045.GA2240@us.ibm.com>
 <20121116125154.GB1121@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121116125154.GB1121@krava.brq.redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111619-5806-0000-0000-00001BDF82E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa [jolsa@redhat.com] wrote:
| > 
| > Can we remove the assumption that the event id is a generic event that
| > has PERF_COUNT_HW_ prefix and also let the architectures pass in a "show"
| > function ? This would allow architectures to display any arch specific
| > events that don't yet have a generic counterpart.
| > 
| > IOW, can we do something like this (untested) and make PERF_EVENT_ATTR global:
| 
| hm, then you probably can use following:
| 
| http://www.spinics.net/lists/kernel/msg1434233.html

For now, power events can simply be u64 - so am hoping to have something
like this and replace the raw codes:

#define PM_CYC			0x1e
#define PM_GCT_NOSLOT_CYC	0x100f8

EVENT_ATTR_STR() is interesting, but would require new/extra macros like

#define PM_CYC_STR		"0x1e"
#define PM_GCT_NOSLOT_CYC_STR	"0x100f8"

I went down the path we discussed earlier - to have x86 and Power share
the EVENT_ATTR() macros. This is making the x86 code less concise

	EVENT_ATTR(cpu-cycles,	CPU_CYCLES)

becomes

	EVENT_ATTR(cpu-cycles,	PERF_COUNT_HW_CPU_CYCLES, events_sysfs_show)

with each EVENT_ATTR() explcitly adding events_sysfs_show or needing another
wrapper around the wrappers.

Still tweaking it, but would it be flexible to make 'struct pmu_events_attr'
common and let architectures define the EVENT_ATTR() as needed ? Would
duplicate some code but hopefully not a lot.

Sukadev

