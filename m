Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0KIWNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:13:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53955 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab0KIWNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:13:48 -0500
Date: Tue, 9 Nov 2010 14:13:38 -0800
From: Greg KH <gregkh@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>, Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH] perf: sysfs type id
Message-ID: <20101109221338.GA19947@suse.de>
References: <1289339119.2191.92.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289339119.2191.92.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 10:45:19PM +0100, Peter Zijlstra wrote:
> The below is a RFC patch adding dynamic type ids to perf.
> 
> We need to represent PMUs in sysfs because we want to allow multiple
> (loadable) PMUs and need a way to identify them.
> 
> This patch creates a new device class "pmu" and adds a single attribute
> "type" to it. This device attribute will expose the dynamic type id as
> required by perf_event_attr::type.
> 
> The sysfs layout looks like:
> 
> [root@westmere ~]# cd /sys/class/pmu/

You missed the embedded track at Plumbers where we talked about never
adding another class to the kernel.  Please use bus_id instead for this.

> [root@westmere pmu]# ls -la
> total 0
> drwxr-xr-x  2 root root 0 2010-11-09 22:22 .
> drwxr-xr-x 47 root root 0 2010-11-09 22:22 ..
> lrwxrwxrwx  1 root root 0 2010-11-09 22:22 breakpoint -> ../../devices/virtual/pmu/breakpoint
> lrwxrwxrwx  1 root root 0 2010-11-09 22:22 cpu -> ../../devices/virtual/pmu/cpu
> lrwxrwxrwx  1 root root 0 2010-11-09 22:22 frob -> ../../devices/virtual/pmu/frob
> lrwxrwxrwx  1 root root 0 2010-11-09 22:22 software -> ../../devices/virtual/pmu/software
> lrwxrwxrwx  1 root root 0 2010-11-09 22:22 tracepoint -> ../../devices/virtual/pmu/tracepoint
> [root@westmere pmu]# cd frob/
> [root@westmere frob]# ls -la
> total 0
> drwxr-xr-x 3 root root    0 2010-11-09 22:22 .
> drwxr-xr-x 7 root root    0 2010-11-09 22:22 ..
> drwxr-xr-x 2 root root    0 2010-11-09 22:23 power
> lrwxrwxrwx 1 root root    0 2010-11-09 22:23 subsystem -> ../../../../class/pmu
> -r--r--r-- 1 root root 4096 2010-11-09 22:23 type
> -rw-r--r-- 1 root root 4096 2010-11-09 22:22 uevent
> [root@westmere frob]# cat type 
> 6
> 
> Not at all sure what all those power bits mean, Greg?

All devices get a "default" power directory by the core, not much you
can do about it.

thanks,

greg k-h
