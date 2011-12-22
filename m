Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1LVCCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 21:02:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40392 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab1LVCCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 21:02:04 -0500
Date: Wed, 21 Dec 2011 18:01:57 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: tip-bot for Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        pjt@google.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:sched/core] sched: Fix cgroup movement of forking process
Message-ID: <20111222020157.GR9213@google.com>
References: <20111215143655.662676b0.nishimura@mxp.nes.nec.co.jp>
 <tip-4fc420c91f53e0a9f95665c6b14a1983716081e7@git.kernel.org>
 <20111221172632.GD9213@google.com>
 <20111221173733.GF9213@google.com>
 <20111222015440.GM17668@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222015440.GM17668@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 22, 2011 at 02:54:42AM +0100, Frederic Weisbecker wrote:
> > Frederic, so, it seems we actually have race conditions here.  I
> > really wish cgroup made sure that things like this can't happen even
> > if we pay a bit of overhead in relatively cold paths.  I could be
> > being unrealistic tho.  Any ideas?
> 
> Hmm, I'm a bit confused about the issue. But doesn't this patch fix the issue?

Yeah, I was just saying it would be nice if we don't have to fix the
issue.

> Also the parent can't be calling sched_fork() and cgroup_exit() at
> the same time.

Hmmm... so this one can't happen anymore but there are races involving
cgroup_exit() which doesn't have anything to do with threadgroup lock
(Dalsuke has more patches), so this doesn't really matter.  Let's
forget about this thread.

Thanks.

-- 
tejun
