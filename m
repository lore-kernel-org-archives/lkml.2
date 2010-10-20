Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0JTBrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 21:47:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:41373 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab0JTBrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 21:47:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,353,1283756400"; 
   d="scan'208";a="848926221"
Date: Wed, 20 Oct 2010 09:47:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        figo1802 <figo1802@gmail.com>
Subject: Re: oom_killer crash linux system
Message-ID: <20101020014746.GA8338@localhost>
References: <20101018021126.GB8654@localhost>
 <1287389631.1997.9.camel@myhost>
 <20101018180919.3AF8.A69D9226@jp.fujitsu.com>
 <1287454058.2078.12.camel@myhost>
 <20101019152249.e268b1e9.kamezawa.hiroyu@jp.fujitsu.com>
 <1287538607.2031.5.camel@myhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287538607.2031.5.camel@myhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 09:36:47AM +0800, Figo.zhang wrote:
> >
> > >
> > > echo 5 > /proc/sys/vm/dirty_ratio
> >
> > reduce the dirty_ratio, i can use memory up to 1.75GB, and then it
> will
> > call oom-killer.
> >So it helps.  Are there intensive IO after reducing dirty_ratio?
> 
> > > - enable vmscan trace
> > >
> > > mount -t debugfs none /sys/kernel/debug
> > > echo 1 > /sys/kernel/debug/tracing/events/vmscan/enable
> > > <eat memory and wait for crash>
> > > cat /sys/kernel/debug/tracing/trace > trace.log
> > would you like to help to see the trace.log , i add attached file.
> > There are many vmscan writes showing up in the trace.
> 
> yes, the DiskIO is be not aggressive when i reduce the dirty_ratio, but
> when i use memory up to 1.75GB (total 2GB), the system suddenly crashed.

You seem to use the term "crash" for both "OOM-killed" and "kernel
panic". You mean .36 kernel will panic on memory pressure while .35
kernel will OOM kill the Xorg task?

> when i reboot and want to see the /var/log/message, it is without useful
> information.
> 
> so it is other useful debug approach to find the issue?

Documentation/networking/netconsole.txt

eg. netconsole=@:/eth0,6666@10.239.51.110/00:30:48:fe:19:94

You'll need another machine to catch the panic log.

Thanks,
Fengguang
