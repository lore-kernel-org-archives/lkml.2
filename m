Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1EaM4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:56:25 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45591 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1EaM4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:56:24 -0400
Date: Tue, 31 May 2011 14:56:21 +0200
From: Borislav Petkov <bp@amd64.org>
To: a.p.zijlstra@chello.nl
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        markus@trippelsdorf.de, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Fix cross-cpu clock sync on remote
 wakeups
Message-ID: <20110531125621.GA24439@gere.osrc.amd.com>
References: <1306835745.2353.3.camel@twins>
 <tip-f01114cb59d670e9b4f2c335930dd57db96e9360@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-f01114cb59d670e9b4f2c335930dd57db96e9360@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Peter,

On Tue, May 31, 2011 at 12:31:20PM +0000, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  f01114cb59d670e9b4f2c335930dd57db96e9360
> Gitweb:     http://git.kernel.org/tip/f01114cb59d670e9b4f2c335930dd57db96e9360
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Tue, 31 May 2011 12:26:55 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 31 May 2011 14:19:56 +0200
> 
> sched: Fix cross-cpu clock sync on remote wakeups
> 
> Markus reported that commit 317f394160e ("sched: Move the second half
> of ttwu() to the remote cpu") caused some accounting funnies on his AMD
> Phenom II X4, such as weird 'top' results.
> 
> It turns out that this is due to non-synced TSC

this would mean that his machine doesn't pass the TSC sync check at boot
but that's a F10h and they usu. have synchronized TSCs?

I'm confused.

> and the queued remote
> wakeups stopped coupeling the two relevant cpu clocks, which leads to
> wakeups seeing time jumps, which in turn lead to skewed runtime stats.
> 
> Add an explicit call to sched_clock_cpu() to couple the per-cpu clocks
> to restore the normal flow of time.
> 
> Reported-and-tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/1306835745.2353.3.camel@twins
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
