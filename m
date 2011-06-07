Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1FGMj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:39:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42171 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab1FGMj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:39:27 -0400
Subject: Re: [tip:sched/urgent] lockdep: Fix lock_is_held() on recursion
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: lists@die-jansens.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-f2513cde93f0957d5dc6c09bc24b0cccd27d8e1d@git.kernel.org>
References: <1307398759.2497.966.camel@laptop>
	 <tip-f2513cde93f0957d5dc6c09bc24b0cccd27d8e1d@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Jun 2011 14:39:03 +0200
Message-ID: <1307450343.2322.250.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 12:02 +0000, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  f2513cde93f0957d5dc6c09bc24b0cccd27d8e1d
> Gitweb:     http://git.kernel.org/tip/f2513cde93f0957d5dc6c09bc24b0cccd27d8e1d
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Mon, 6 Jun 2011 12:32:43 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 7 Jun 2011 12:25:50 +0200
> 
> lockdep: Fix lock_is_held() on recursion
> 
> The main lock_is_held() user is lockdep_assert_held(), avoid false
> assertions in lockdep_off() sections by unconditionally reporting the
> lock is taken.
> 
> [ the reason this is important is a lockdep_assert_held() in ttwu()
>   which triggers a warning under lockdep_off() as in printk() which
>   can trigger another wakeup and lock up due to spinlock
>   recursion, as reported and heroically debugged by Arne Jansen ]
> 
> Reported-and-tested-by: Arne Jansen <lists@die-jansens.de>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: <stable@kernel.org>

Not _that_ critical for stable since the offending lockdep_assert_held()
doesn't exist in .39, still definitely won't hurt.

