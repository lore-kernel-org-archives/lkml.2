Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab2KPMwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 07:52:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab2KPMwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 07:52:14 -0500
Date: Fri, 16 Nov 2012 13:51:54 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, robert.richter@amd.com,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] perf/POWER7: Make event translations available in
 sysfs
Message-ID: <20121116125154.GB1121@krava.brq.redhat.com>
References: <20121107191818.GA16211@us.ibm.com>
 <20121107191927.GC16211@us.ibm.com>
 <20121114102534.GA2220@krava.brq.redhat.com>
 <20121114182045.GA2240@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114182045.GA2240@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 10:20:45AM -0800, Sukadev Bhattiprolu wrote:
> Jiri Olsa [jolsa@redhat.com] wrote:
> | On Wed, Nov 07, 2012 at 11:19:28AM -0800, Sukadev Bhattiprolu wrote:
> | 
> | SNIP
> | 
> | > +struct perf_pmu_events_attr {
> | > +	struct device_attribute attr;
> | > +	u64 id;
> | > +};
> | > +
> | > +extern ssize_t power_events_sysfs_show(struct device *dev,
> | > +				struct device_attribute *attr, char *page);
> | > +
> | > +#define EVENT_VAR(_id)	event_attr_##_id
> | > +#define EVENT_PTR(_id) &event_attr_##_id.attr.attr
> | > +
> | > +#define EVENT_ATTR(_name, _id)                                             \
> | > +	static struct perf_pmu_events_attr EVENT_VAR(_id) = {              \
> | > +		.attr = __ATTR(_name, 0444, power_events_sysfs_show, NULL),\
> | > +		.id   = PM_##_id,                                               \
> | > +	};
> | 
> | this is duplicating the x86 code, perhaps it could be moved
> | to include/linux/perf_event.h and shared globaly
> 
> Ok.
> 
> Can we remove the assumption that the event id is a generic event that
> has PERF_COUNT_HW_ prefix and also let the architectures pass in a "show"
> function ? This would allow architectures to display any arch specific
> events that don't yet have a generic counterpart.
> 
> IOW, can we do something like this (untested) and make PERF_EVENT_ATTR global:

hm, then you probably can use following:

http://www.spinics.net/lists/kernel/msg1434233.html
http://www.spinics.net/lists/kernel/msg1434235.html
http://www.spinics.net/lists/kernel/msg1434226.html

jirka
