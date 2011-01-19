Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab1ASAYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 19:24:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab1ASAYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 19:24:18 -0500
Date: Tue, 18 Jan 2011 19:23:40 -0500
From: Don Zickus <dzickus@redhat.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        stable@kernel.org
Subject: Re: [PATCH 1/3] watchdog: fix broken nowatchdog logic
Message-ID: <20110119002340.GB31465@redhat.com>
References: <1295390266-9347-1-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295390266-9347-1-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 11:37:44PM +0100, Marcin Slusarz wrote:
> Passing nowatchdog to kernel disables 2 things: creation of watchdog threads
> AND initialization of percpu watchdog_hrtimer. As hrtimers are initialized
> only at boot it's not possible to enable watchdog later - for me all watchdog
> threads started to eat 100% of CPU time, but they could just crash.
> 
> Additionally, even if these threads would start properly,
> watchdog_disable_all_cpus was guarded by no_watchdog check, so you
> couldn't disable watchdog.
> 
> To fix this, remove no_watchdog variable and use already existing
> watchdog_enabled variable.

These three patches seem reasonable.  I'll queue them up.

Thanks,
Don
