Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab2DNUSc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 16:18:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab2DNUSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 16:18:31 -0400
Date: Sat, 14 Apr 2012 22:17:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] task_work_add (was: task_work_queue)
Message-ID: <20120414201748.GA8482@redhat.com>
References: <20120414021201.GA23385@redhat.com> <1334426937.2528.108.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334426937.2528.108.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14, Peter Zijlstra wrote:
>
> Can you use this to get rid of TIF_UPROBE as well?

Yes, I thought about uprobes. May be it can use task_work, but
it is not easy to avoid TIF_UPROBE. The problem is the first
UTASK_BP_HIT when current->utask == NULL, and ->utask is the
only "right" place to hold task_work. We will see.

Oleg.

