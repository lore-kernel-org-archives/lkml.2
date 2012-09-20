Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2ITSNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:13:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49469 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333Ab2ITSNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:13:02 -0400
Date: Thu, 20 Sep 2012 20:12:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tejun Heo <tj@kernel.org>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at kernel/sched/core.c:1465!
Message-ID: <20120920181258.GA17181@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
	Michael Wang <wangyun@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>
References: <20120919091230.GA25576@liondog.tnic>
 <505AB9F7.6030605@linux.vnet.ibm.com>
 <20120920125801.GA15045@x1.osrc.amd.com>
 <20120920171045.GC28934@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120920171045.GC28934@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 10:10:45AM -0700, Tejun Heo wrote:
> Yeah, it's powernow-k8 migrating kworker to a different CPU. It's
> really curious that there are multiple reports of this in this cycle.
> Nothing on workqueue side has changed and powernow-k8 has been
> broken for very long time. The only way this can get triggered is by
> contending on fidvid_mutex in powernow-k8. I suppose something changed
> in such way that this happens with some regularity. Have no specific
> idea what. Anyways, mainline should be okay now.

Yep, it is. I'm running with it for a couple of hours already and no
issues.

Btw, we'd normally investigate why powernow-k8 b0rkage appears now
but after the next merge window, that functionality is moving to
acpi-cpufreq so powernow-k8 should really be only for K8s then.

We'll see how that whole thing pans out as late as 3.7-rc cycle.

Thanks.

-- 
Regards/Gruss,
    Boris.
