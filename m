Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1JCBWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 21:22:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34474 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1JCBWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 21:22:48 -0400
Date: Sun, 2 Oct 2011 18:22:44 -0700
From: Tejun Heo <htejun@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
Message-ID: <20111003012244.GF31799@mtj.dyndns.org>
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
 <20110930034815.GF10425@mtj.dyndns.org>
 <1317374865.19415.15.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317374865.19415.15.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 11:27:45AM +0200, Peter Zijlstra wrote:
> There is no correctness issue what so ever with those, and userspace
> moving them about doesn't matter one whit.

I wanted to make it consistent and disallow diddling wq worker
affinity from userland.  As those workers are shared and managed
dynamically, it didn't make sense to allow affinity manipulation.
That said, it might make sense allowing control over affinity of
unbound wq workers for things like cpu isolation.  Userspace doing
that per-worker doesn't make whole lot of sense.  Allowing putting
unbound workers automatically into a cpuset would work better, I
think.

Thanks.

-- 
tejun
