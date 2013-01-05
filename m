Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab3AEBru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 20:47:50 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44689 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab3AEBrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 20:47:47 -0500
Date: Fri, 4 Jan 2013 17:47:41 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, robert.richter@amd.com,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/5] perf: Make EVENT_ATTR and EVENT_PTR global
Message-ID: <20130105014741.GA4438@us.ibm.com>
References: <20121219072802.GA30790@us.ibm.com>
 <20130102145850.GE931@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130102145850.GE931@krava.brq.redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010501-9360-0000-0000-00000ECA40F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa [jolsa@redhat.com] wrote:
| On Tue, Dec 18, 2012 at 11:28:02PM -0800, Sukadev Bhattiprolu wrote:
| > 
| > Rename EVENT_ATTR() and EVENT_PTR() PMU_EVENT_ATTR() and PMU_EVENT_PTR().
| > Make them global so they are available to all architectures.
| > 
| > Further to allow architectures flexibility, have PMU_EVENT_PTR() pass in the
| > variable name as a parameter.
| > 
| hi,
| the change looks ok apart from some nits below.
| 
| There' another version of the x86 event attributes change
| I mentioned earlier:
| 
| http://marc.info/?l=linux-kernel&m=135601815224373&w=2
| 
| I'm not sure which one will make it in first, but you
| guys need to sync ;-) CC-ing Andi and Stephane.

One change that would help powerpc (and other architectures) is to move
the 'struct perf_pmu_events_attr' to say, include/linux/perf_event.h.

Each architecture can define EVENT_VAR(), EVENT_PTR() etc as needed.

| 
| thanks,
| jirka
| 

<snip>

| > +struct perf_pmu_events_attr {
| > +	struct device_attribute attr;
| > +	u64 id;
| > +};
| > +
| > +#define PMU_EVENT_PTR(_var)	&_var.attr.attr
| 
| this one seems superfluous as well, could be replaced by '&'

I guess that would encode the assumption that both the 'attr' fields are 
the first in their respective structures. If so, an explicit comment beside
the fields would be useful.

Sukadev

