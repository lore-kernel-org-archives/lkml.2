Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0F1VEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:04:35 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48867 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab0F1VEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:04:33 -0400
Date: Mon, 28 Jun 2010 14:03:42 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sanitize task->comm to avoid leaking escape codes
Message-ID: <20100628210342.GW4175@outflux.net>
References: <20100623181129.GM5876@outflux.net>
 <20100623194145.GA19628@redhat.com>
 <20100623202335.GA4424@x200>
 <20100628130028.73757a46.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100628130028.73757a46.akpm@linux-foundation.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 28, 2010 at 01:00:28PM -0700, Andrew Morton wrote:
> Surely it would be better to fix the tools which display this info
> rather than making the kernel tell fibs.

The strncpy in get_task_comm() is totally wrong -- it's testing the length
of task->comm.  Why should get_task_comm not take a destination buffer
length argument?  At least consider v2 of the patch -- it just fixes the
get_task_comm definition and callers.

But, if not, then patches to the kernel that include
printk(..., get_task_comm(...) ...) shouldn't be considered flawed[1].

-Kees

[1] http://lkml.org/lkml/2010/6/23/132

-- 
Kees Cook
Ubuntu Security Team
