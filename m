Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0GWD5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 23:57:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44383 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab0GWD5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 23:57:38 -0400
X-Authority-Analysis: v=1.1 cv=NvN00vXXLC/2Fo3NdLZJXFUM7u9qr/FOWvgMjmHRJhk= c=1 sm=0 a=yRs0Bdu_tHsA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=7cxh9BZpSVGz3-NWGiIA:9 a=cuhv01bmcD8hfrMHNN-qYYLayr4A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC][PATCH v1 06/15] perf: export tracepoint events via
 sysfs: iwlwifi and iwlwifi_io
From: Steven Rostedt <rostedt@goodmis.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Ingo Molnar <mingo@elte.hu>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        Robert Richter <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1279853134.24607.38.camel@minggr.sh.intel.com>
References: <1279797230.20942.87.camel@minggr.sh.intel.com>
	 <1279797640.12439.11.camel@jlt3.sipsolutions.net>
	 <1279805440.3319.2.camel@gandalf.stny.rr.com>
	 <20100722134836.GA6881@elte.hu>
	 <1279806844.3319.3.camel@gandalf.stny.rr.com>
	 <20100723013716.GA7362@dastard>
	 <1279851241.3319.31.camel@gandalf.stny.rr.com>
	 <1279853134.24607.38.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 22 Jul 2010 23:57:34 -0400
Message-ID: <1279857454.3319.34.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-23 at 10:45 +0800, Lin Ming wrote:
> On Fri, 2010-07-23 at 10:14 +0800, Steven Rostedt wrote:

> Does this "TRACE_CATEGORY()" can help to specify different event
> attribute value?
> 
> /sys/devices/pci0000:00/0000:00:02.0/drm/card0/events
> |-- i915_gem_object_bind
> |   |-- config
> |   |-- type
> |   |-- filter  ==> filter for card0
> 
> /sys/devices/pci0000:00/0000:00:02.0/drm/card1/events
> |-- i915_gem_object_bind
> |   |-- config
> |   |-- type
> |   |-- filter  ==> filter for card1
> 
> In above example, the values of "config" and "type" are same.
> But the values of "filter" are different.

No, it does not make a single event with different atts. It is just a
way to group events.

What you are showing is two events with the same name under two
different groups. But there still only exists one event (the place that
trace_i915_gem_object_bind() is located).

-- Steve


