Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0IGM1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:27:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:44424 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256Ab0IGM1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:27:04 -0400
Message-ID: <4C862F8E.7030507@kernel.org>
Date: Tue, 07 Sep 2010 14:26:54 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org> <20100907100108.GN705@dastard> <4C861582.6080102@kernel.org>
In-Reply-To: <4C861582.6080102@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Sep 2010 12:26:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2010 12:35 PM, Tejun Heo wrote:
> Can you please help me a bit more?  Are you saying the following?
> 
> Work w0 starts execution on wq0.  w0 tries locking but fails.  Does
> delay(1) and requeues itself on wq0 hoping another work w1 would be
> queued on wq0 which will release the lock.  The requeueing should make
> w0 queued and executed after w1, but instead w1 never gets executed
> while w0 hogs the CPU constantly by re-executing itself.  Also, how
> does delay(1) help with chewing up CPU?  Are you talking about
> avoiding constant lock/unlock ops starving other lockers?  In such
> case, wouldn't cpu_relax() make more sense?

Ooh, almost forgot.  There was nr_active underflow bug in workqueue
code which could lead to malfunctioning max_active regulation and
problems during queue freezing, so you could be hitting that too.  I
sent out pull request some time ago but hasn't been pulled into
mainline yet.  Can you please pull from the following branch and add
WQ_HIGHPRI as discussed before and see whether the problem is still
reproducible?  And if the problem is reproducible, can you please
trigger sysrq thread dump and attach it?

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

Thanks.

-- 
tejun
