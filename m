Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031242Ab2CFVCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:02:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42395 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031207Ab2CFVCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:02:42 -0500
Message-ID: <1331067743.11248.333.camel@twins>
Subject: Re: [PATCH bisected regression] sched: rebuild sched domains at
 suspend/resume
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 06 Mar 2012 22:02:23 +0100
In-Reply-To: <20120306204357.13169.90791.stgit@zurg>
References: <20120306204357.13169.90791.stgit@zurg>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 00:45 +0400, Konstantin Khlebnikov wrote:
> This is fix for suspend/resume regression introduced in commit 8f2f748b0656
> ("CPU hotplug, cpusets, suspend: Don't touch cpusets during suspend/resume")
> Without this patch suspend always hangs on my thinkpad x220 (2 x CPU * HT).
> 
> cpuset_update_active_cpus() not only juggles with bits in cpusets,
> it also calls sched-domains rebuilding after all.
> 
> This patch restores sched-domain rebuilds, as it was before that commit.

This changelog also completely fails to explain what the problem was and
how this patch sorts it without re-introducing the problems 8f2f748b0656
was supposed to fix.

I'd rather revert the 'fix' and think about this more (its been broken
pretty much forever anyway) than tinker on top like this.
