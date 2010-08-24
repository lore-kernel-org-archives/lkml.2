Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0HXCLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 22:11:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:44190 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab0HXCLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 22:11:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,260,1280732400"; 
   d="scan'208";a="599514989"
Date: Tue, 24 Aug 2010 10:11:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Michael Rubin <mrubin@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 4/4] writeback: Reporting dirty thresholds in
 /proc/vmstat
Message-ID: <20100824021136.GA9254@localhost>
References: <20100821054808.GA29869@localhost>
 <AANLkTikS+DUfPz0E2SmCZTQBWL8h2zSsGM8--yqEaVgZ@mail.gmail.com>
 <20100824100943.F3B6.A69D9226@jp.fujitsu.com>
 <AANLkTi=OwGUzM0oZ5qTEFnGTuo8kVfW79oqH-Dcf8jdp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=OwGUzM0oZ5qTEFnGTuo8kVfW79oqH-Dcf8jdp@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right now we don't mount all of debugfs at boot time. We have not done
> the work to verify its safe in our environment. It's mostly a nit.

You work discreetly, that's a good thing. Note that most
sub-directories under debugfs can be turned off in kconfig.

> Also I was under the impression that debugfs was intended more for
> kernel devs while /proc and /sys was intended for application
> developers.

I guess the keyword here is "debugging/diagnosing". Think about
/debug/tracing. DirtyThresh seems like the same stuff.

> >> 3) Full system counters are easier to handle the juggling of removable
> >> storage where these numbers will appear and disappear due to being
> >> dynamic.
> 
> This is the biggie to me. The idea is to get a complete view of the
> system's writeback behaviour over time. With systems with hot plug
> devices, or many many drives collecting that view gets difficult.

Sorry for giving a wrong example. Hope this one is better:

$ cat /debug/bdi/default/stats
[...]
DirtyThresh:       1838904 kB
BackgroundThresh:   919452 kB
[...]

It's a trick to avoid messing with real devices :)

Thanks,
Fengguang
