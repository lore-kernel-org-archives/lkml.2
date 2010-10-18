Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab0JRPbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:31:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:54664 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab0JRPbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:31:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,345,1283756400"; 
   d="scan'208";a="565055800"
Date: Mon, 18 Oct 2010 23:31:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Figo.zhang" <zhangtianfei@leadcoretech.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        figo1802 <figo1802@gmail.com>
Subject: Re: oom_killer crash linux system
Message-ID: <20101018153109.GA29500@localhost>
References: <20101018021126.GB8654@localhost>
 <1287389631.1997.9.camel@myhost>
 <20101018180919.3AF8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018180919.3AF8.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 05:10:00PM +0800, KOSAKI Motohiro wrote:
> > 
> > i want to test the oom-killer. My desktop (Dell optiplex 780, i686
> > kernel)have 2GB ram, i turn off the swap partition, and open a huge pdf
> > files and applications, and let the system eat huge ram.
> > 
> > in 2.6.35, i can use ram up to 1.75GB,
> > 
> > but in 2.6.36-rc8, i just use to 1.53GB ram , the system come very slow
> > and crashed after some minutes , the DiskIO is very busy. i see the
> > DiskIO read is up to 8MB/s, write just only 400KB/s, (see by conky).

There are much more reads than writes, it looks like some thrashing.
How do you measure the 1.75GB/1.53GB?

> > what change between 2.6.35 to 2.6.36-rc8? is it low performance about
> > page reclaim and page writeback in high press ram useage?
> 
> very lots of change ;)
> can you please send us your crash log?

And there are several ways to help debug the problem.

- reduce the dirty limit

echo 5 > /proc/sys/vm/dirty_ratio

- enable vmscan trace

mount -t debugfs none /sys/kernel/debug
echo 1 > /sys/kernel/debug/tracing/events/vmscan/enable
<eat memory and wait for crash>
cat /sys/kernel/debug/tracing/trace > trace.log

- log vmstat events

i=1
while true;
do
        cp /proc/vmstat vmstat.$i
        let i=i+1
        sleep 1
done

Thanks,
Fengguang
