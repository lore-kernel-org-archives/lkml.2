Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1AaKcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:32:33 -0500
Received: from www.tglx.de ([62.245.132.106]:52561 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442Ab1AaKcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:32:31 -0500
Date: Mon, 31 Jan 2011 11:32:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Torben Hohn <torbenh@gmx.de>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        johnstul@us.ibm.com, hch@infradead.org, yong.zhang0@gmail.com,
        Matt Turner <mattst88@gmail.com>, Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v2 05/20] alpha: change do_timer() to xtime_update()
In-Reply-To: <alpine.LFD.2.00.1101311120530.31804@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1101311131470.31804@localhost6.localdomain6>
References: <20110127145741.23248.68098.stgit@localhost> <20110127145915.23248.20919.stgit@localhost> <alpine.LFD.2.00.1101311120530.31804@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, Thomas Gleixner wrote:

> On Thu, 27 Jan 2011, Torben Hohn wrote:
> 
> > xtime_update() takes the xtime_lock itself.
> > state does not to be protected with this lock.
> > its only touched here and during init.
> 
> xtime_lock very well serializes the access to state on
> SMP. timer_interrupt() is called on each cpu. So that wont work.

Hmm. No. It's bound to boot_cpu_id.
