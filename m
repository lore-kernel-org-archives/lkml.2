Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab0FOD0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 23:26:18 -0400
Received: from ozlabs.org ([203.10.76.45]:49191 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab0FOD0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 23:26:17 -0400
Date: Tue, 15 Jun 2010 13:26:08 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tytso@mit.edu, Salman <sqazi@google.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tytso@google.com,
       torvalds@linux-foundation.org, walken@google.com,
       Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
Message-ID: <20100615032608.GB30479@drongo>
References: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com>
 <20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
 <20100614165851.6bdfe485.akpm@linux-foundation.org>
 <20100615005619.GI6666@thunk.org>
 <20100614185556.afdc5304.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614185556.afdc5304.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 06:55:56PM -0700, Andrew Morton wrote:

> > kernel/sched_clock.c:   if (cmpxchg64(&scd->clock, old_clock, clock) != old_cloc
> 
> I guess that'll flush out any stragglers.

And break most non-x86 32-bit architectures, including 32-bit powerpc.
Fortunately that code is only used if CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
is set, and it looks like only x86 and ia64 set it.

Paul.
