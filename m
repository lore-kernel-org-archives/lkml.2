Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab2CMNm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:42:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab2CMNm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:42:56 -0400
Date: Tue, 13 Mar 2012 09:42:24 -0400
From: Don Zickus <dzickus@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] watchdog: make sure the watchdog thread gets CPU on
 loaded system
Message-ID: <20120313134224.GU24378@redhat.com>
References: <1331631922-10466-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331631922-10466-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 10:45:22AM +0100, Michal Hocko wrote:
> If the system is loaded while hotplugging a CPU we might end up with a bogus
> hardlockup detection. This has been seen during LTP pounder test executed
> in parallel with hotplug test.
> 
> The main problem is that enable_watchdog (called when CPU is brought up)
> registers perf event which periodically checks per-cpu counter
> (hrtimer_interrupts), updated from a hrtimer callback, but the hrtimer is fired
> from the kernel thread.

Seems reasonable to me.  I'll apply it.

Thanks,
Don
