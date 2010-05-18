Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab0ERSoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:44:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:40301 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab0ERSoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YIjN4NAdYwrOKePULQd+LXPIEM9kLwGrv/c/G+1R5FWWDPjDvMieoKPp7QGMN3zFRK
         aAX0J59HfYKbvLyeOMsP2CYubrHgdyNvLq1CQxvOvOiY0NEPvLS7HNPxygyD6dGUdgzA
         jd1OxXpO37xUjAlZKets+4XE+XzNx7q2GENSI=
Date: Tue, 18 May 2010 22:43:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
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
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH v2 07/11] perf: x86, implements
	pmu::register_events
Message-ID: <20100518184352.GF5081@lenovo>
References: <1274233707.3036.86.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274233707.3036.86.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 01:48:27AM +0000, Lin Ming wrote:
...
> +static int register_event(struct pmu *pmu,
> +		struct kobject *parent_kobj, char *name, u64 id)
> +{
> +	struct perf_event_kobject *event_kobj;
> +	struct attribute *attr;
> +	int err;
> +
> +	event_kobj = kzalloc(sizeof(*event_kobj), GFP_KERNEL);
> +	if (!event_kobj) {
> +		err = -ENOMEM;
> +		goto exit;
> +	}
> +	event_kobj->id = id;
> +
> +	err = kobject_init_and_add(&event_kobj->kobj,
> +		&event_ktype, parent_kobj, name);
> +	if (err)
> +		goto exit;
> +
...

event_kobj seems to be not freed, right?
 
	-- Cyrill
