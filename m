Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab0JRCL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 22:11:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:49206 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab0JRCL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 22:11:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,344,1283756400"; 
   d="scan'208";a="848072285"
Date: Mon, 18 Oct 2010 10:11:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Figo.zhang" <zhangtianfei@leadcoretech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        figo1802 <figo1802@gmail.com>
Subject: Re: oom_killer crash linux system
Message-ID: <20101018021126.GB8654@localhost>
References: <1287366459.2035.1.camel@myhost>
 <20101018105722.03415e48.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018105722.03415e48.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 09:57:22AM +0800, KAMEZAWA Hiroyuki wrote:
> On Mon, 18 Oct 2010 09:47:39 +0800
> "Figo.zhang" <zhangtianfei@leadcoretech.com> wrote:
> 
> > hi all,
> > 
> > i have a desktop run linux2.6.35 and have 2GB ram. i turn off the swap
> > partition, and i open huge applications , let the system eat more and
> > more memory.
> > when the system eat more than 1.7G ram, the system crashed.
> > 
> 
> 2.6.36-rc series has a completely new logic, please try.

And the new logic should help this case.

commit a63d83f427fbce97a6cea0db2e64b0eb8435cd10
Author: David Rientjes <rientjes@google.com>
Date:   Mon Aug 9 17:19:46 2010 -0700

    oom: badness heuristic rewrite
...
    Instead of basing the heuristic on mm->total_vm for each task, the task's
    rss and swap space is used instead.  This is a better indication of the
    amount of memory that will be freeable if the oom killed task is chosen
    and subsequently exits.  This helps specifically in cases where KDE or
    GNOME is chosen for oom kill on desktop systems instead of a memory
    hogging task.
...

Thanks,
Fengguang
