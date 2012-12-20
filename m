Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab2LTFdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 00:33:10 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59920 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875Ab2LTFc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 00:32:59 -0500
X-Sasl-enc: KY96n5QhVyJotItYyTj0EBicjVqGZm+rSwHSEjtJt0fs 1355981578
Date: Wed, 19 Dec 2012 21:36:00 -0800
From: Greg KH <greg@kroah.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        robert.richter@amd.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] perf/POWER7: Make generic event translations
 available in sysfs
Message-ID: <20121220053600.GC28007@kroah.com>
References: <20121219072646.GA30580@us.ibm.com>
 <20121219072848.GB30790@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219072848.GB30790@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 11:28:49PM -0800, Sukadev Bhattiprolu wrote:
> 
> [PATCH 3/5] perf/POWER7: Make generic event translations available in sysfs
> 
> Make the generic perf events in POWER7 available via sysfs.
> 
> 	$ ls /sys/bus/event_source/devices/cpu/events
> 	branch-instructions
> 	branch-misses
> 	cache-misses
> 	cache-references
> 	cpu-cycles
> 	instructions
> 	stalled-cycles-backend
> 	stalled-cycles-frontend
> 
> 	$ cat /sys/bus/event_source/devices/cpu/events/cache-misses
> 	event=0x400f0
> 
> This patch is based on commits that implement this functionality on x86.
> Eg:
> 	commit a47473939db20e3961b200eb00acf5fcf084d755
> 	Author: Jiri Olsa <jolsa@redhat.com>
> 	Date:   Wed Oct 10 14:53:11 2012 +0200
> 
> 	    perf/x86: Make hardware event translations available in sysfs
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ---
>  arch/powerpc/include/asm/perf_event_server.h |   25 +++++++++++++++++++
>  arch/powerpc/perf/core-book3s.c              |   12 +++++++++
>  arch/powerpc/perf/power7-pmu.c               |   34 ++++++++++++++++++++++++++
>  3 files changed, 71 insertions(+), 0 deletions(-)

As you are adding new sysfs files, you must also add new
Documentation/ABI entries at the same time.  Please also do this for the
other patches in this series that add new sysfs files.

thanks,

greg k-h
