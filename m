Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2LYBIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 20:08:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:1260 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab2LYBH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 20:07:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,351,1355126400"; 
   d="scan'208";a="266648675"
Message-ID: <1356397745.2638.21.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH V2] output the cpu number  when printking.
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "he, bo" <bo.he@intel.com>, Randy Dunlap <rdunlap@infradead.org>,
        akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Date: Tue, 25 Dec 2012 09:09:05 +0800
In-Reply-To: <20121224175532.GA15041@kroah.com>
References: <1356316276.2385.7.camel@hebo> <50D7CDED.4060308@infradead.org>
	 <1356321255.2385.8.camel@hebo> <1356325315.2385.74.camel@hebo>
	 <20121224175532.GA15041@kroah.com>
Organization: Intel.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-24 at 09:55 -0800, Greg KH wrote:
> On Mon, Dec 24, 2012 at 01:01:55PM +0800, he, bo wrote:
> > From: "he, bo" <bo.he@intel.com>
> > 
> > We often hit kernel panic issues on SMP machines because processes race
> > on multiple cpu. By adding a new parameter printk.cpu, kernel prints
> > cpu number at printk information line. It’s useful to debug what cpus
> > are racing.
> 
> How useful is this really for normal developers?
It's very useful to debug race conditions under SMP environment.
We applied the patch to our Android build image on our smartphones.

>   We complained when
> this option was proposed by the ARM developers who were, for the first
> time, handling more than one processor and the issues involved with
> that.  You are enabling this as a default option, for all developers,
> and almost no one will ever need it.
At least, I am a developer to use it every day. :). I need debug various
weird issues and tried many debug tools.

Anyway, we would change the default to _disable_.

> 
> So, if you really want this, don't enable this by default.  Also, go
> back and read the old thread about this option and why it was rejeted
> previously.
Thanks for your kind reminder. I googled it. Is the link
like https://lkml.org/lkml/2012/8/3/121?
Or http://lkml.indiana.edu/hypermail/linux/kernel/1208.0/02097.html?

Above links raise a good question that we might be able to use
ftrace (trace_printk) instead of to extend printk.
1) There are indeed lots of debug methods/tools in kernel because of many
excellent developers' contributions. However, the most frequently-used tool
is still printk.
2) ftrace (I use it often) is good when system mostly doesn't crash.
If system crashes, we couldn't get ftrace info sometimes.
When we debug some hard issues on a multi-core device, the system often
crashes when Graphics driver accesses registers incorrectly. There is no chance
for kernel to dump ftrace or panic info. With printk, we find that's because
2 cpu are racing. One cpu turns off Graphics while another cpu is accessing it.
Of course, we also applied the Android persistent ram patch, so after rebooting,
we still could see the printk buffer of previous booting.
3) Current drivers usually have many dev_dbg statements. We could enable
dynamic debug control to get such info quickly. With the printk cpu number
patch, we quickly enhance them to dump info about potential races among cpu.
With ftrace, we need change all these dev_dbg to trace_printk and that's not
the original objective of driver developers.

Mostly, the patch is to reuse all current printk statements in kernel with
a little overhead.

Thanks for your kind comments.

Yanmin


