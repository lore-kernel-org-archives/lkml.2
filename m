Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab0GWRhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:37:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209Ab0GWRhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:37:18 -0400
Date: Fri, 23 Jul 2010 19:34:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, andi.kleen@intel.com,
        stable@kernel.org
Subject: Re: [PATCH] Don't apply for write lock on tasklist_lock if parent
	doesn't ptrace other processes
Message-ID: <20100723173453.GA29831@redhat.com>
References: <1279176663.2096.1264.camel@ymzhang.sh.intel.com> <20100721144944.5351c741.akpm@linux-foundation.org> <20100721222529.EFBAA400B6@magilla.sf.frob.com> <20100722090524.GA6647@redhat.com> <1279874705.2096.1274.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279874705.2096.1274.camel@ymzhang.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23, Zhang, Yanmin wrote:
>
> On Thu, 2010-07-22 at 11:05 +0200, Oleg Nesterov wrote:
> > I am not surpized perf blaims tasklist, but I am really surpized this patch
> > adds 10% improvement...
> I changed aim7 workfile to focus on fork/exec and other a couple of sub-cases.
> And this behavior is clear on 8-socket machines. 

Thanks...

> After applying my patch (although it's incorrect as there is a race with TRACEME),
> perf shows write_lock_irq in forget_original_parent consumes less than 40% cpu time on
> 8-socket machine.

Any chance you can test the patch I sent? It should have the same effect,
otherwise there is something interesting.

> Is it possible to optimize it to use finer locks instead of the global tasklist_lock?

Heh. We must optimize it. But it is not clear when ;)

Oleg.

