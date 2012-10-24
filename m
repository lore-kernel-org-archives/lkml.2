Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab2JXU2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:28:39 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60927 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab2JXU2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:28:37 -0400
Message-ID: <50884F63.8030606@linux.vnet.ibm.com>
Date: Wed, 24 Oct 2012 13:28:19 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
References: <20121012125708.GJ10110@dhcp22.suse.cz> <20121023164546.747e90f6.akpm@linux-foundation.org> <20121024062938.GA6119@dhcp22.suse.cz> <20121024125439.c17a510e.akpm@linux-foundation.org>
In-Reply-To: <20121024125439.c17a510e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102420-2876-0000-0000-00000154F125
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 12:54 PM, Andrew Morton wrote:
> hmpf.  This patch worries me.  If there are people out there who are
> regularly using drop_caches because the VM sucks, it seems pretty
> obnoxious of us to go dumping stuff into their syslog.  What are they
> supposed to do?  Stop using drop_caches?

People use drop_caches because they _think_ the VM sucks, or they
_think_ they're "tuning" their system.  _They_ are supposed to stop
using drop_caches. :)

What kind of interface _is_ it in the first place?  Is it really a
production-level thing that we expect users to be poking at?  Or, is it
a rarely-used debugging and benchmarking knob which is fair game for us
to tweak like this?

Do we have any valid uses of drop_caches where the printk() would truly
_be_ disruptive?  Are those cases where we _also_ have real kernel bugs
or issues that we should be working?  If it disrupts them and they go to
their vendor or the community directly, it gives us at least a shot at
fixing the real problems (or fixing the "invalid" use).

Adding taint, making this a single-shot printk, or adding vmstat
counters are all good ideas.  I guess I think the disruption is a
feature because I hope it will draw some folks out of the woodwork.

