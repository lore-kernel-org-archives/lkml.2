Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2CXQoN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 12:44:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59865 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab2CXQoL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 12:44:11 -0400
Message-ID: <1332607407.16159.51.camel@twins>
Subject: Re: [PATCH 10/10] oom: Make find_lock_task_mm() sparse-aware
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 24 Mar 2012 17:43:27 +0100
In-Reply-To: <20120324162151.GA3640@lizard>
References: <20120324102609.GA28356@lizard> <20120324103127.GJ29067@lizard>
	 <1332593574.16159.31.camel@twins> <20120324162151.GA3640@lizard>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-24 at 20:21 +0400, Anton Vorontsov wrote:

> Just wonder how do you see the feature implemented?
> 
> Something like this?
> 
> #define __ret_cond_locked(l, c)	__attribute__((ret_cond_locked(l, c)))
> #define __ret_value		__attribute__((ret_value))
> #define __ret_locked_nonnull(l)	__ret_cond_locked(l, __ret_value);
> 
> extern struct task_struct *find_lock_task_mm(struct task_struct *p)
> 	__ret_locked_nonnull(&__ret_value->alloc_lock);

Yeah, see the email I just CC'ed you on to linux-sparse.

Basically extend __attribute__((context())) to allow things similar to
what you proposed.
