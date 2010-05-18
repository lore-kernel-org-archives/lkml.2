Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab0ERUOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:14:18 -0400
Received: from kroah.org ([198.145.64.141]:52547 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758043Ab0ERUOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:14:16 -0400
Date: Tue, 18 May 2010 13:05:24 -0700
From: Greg KH <greg@kroah.com>
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
       Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs
Message-ID: <20100518200524.GA20223@kroah.com>
References: <1274233602.3036.84.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274233602.3036.84.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 01:46:42AM +0000, Lin Ming wrote:
> Now only exports cpu hardware events.
> 
> For each PMU, there are 2 sysfs dirs: event_source and events.
> 
> For example,
> /sys/devices/system/cpu/event_source/
> /sys/devices/system/cpu/events/
> 
> $ tree /sys/devices/system/cpu/event_source/
> /sys/devices/system/cpu/event_source/
> `-- id
> 
> $ tree /sys/devices/system/cpu/events/
> /sys/devices/system/cpu/events/
> |-- L1-dcache-load-misses
> |   |-- event_source -> ../../event_source

What is this symlink for?  Is it needed as they all seem to point to the
same thing.

Also, as you are trying to add new sysfs interfaces, please document
them in Documentation/ABI.

And, do you have to use "raw" kobjects here?  Any chance you can use a
struct device instead?

I'm still not really understanding what exactly you are trying to show
in the sysfs tree here anyway, perhaps the documentation update will
clear that up for me.

thanks,

greg k-h
