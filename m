Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab1HJC7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 22:59:01 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43512 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1HJC7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 22:59:00 -0400
Date: Wed, 10 Aug 2011 10:58:45 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, sergey.senozhatsky@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] lockdep: Fix wrong assumption in
 match_held_lock
Message-ID: <20110810025845.GA5640@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1312547787.28695.2.camel@twins>
 <tip-80e0401e35410a69bfae05b454db8a7187edd6b8@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-80e0401e35410a69bfae05b454db8a7187edd6b8@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 02:30:02PM +0000, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  80e0401e35410a69bfae05b454db8a7187edd6b8
> Gitweb:     http://git.kernel.org/tip/80e0401e35410a69bfae05b454db8a7187edd6b8
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Fri, 5 Aug 2011 14:26:17 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 9 Aug 2011 11:57:35 +0200
> 
> lockdep: Fix wrong assumption in match_held_lock
> 
> match_held_lock() was assuming it was being called on a lock class
> that had already seen usage.
> 
> This condition was true for bug-free code using lockdep_assert_held(),
> since you're in fact holding the lock when calling it. However the
> assumption fails the moment you assume the assertion can fail, which
> is the whole point of having the assertion in the first place.
> 
> Anyway, now that there's more lockdep_is_held() users, notably
> __rcu_dereference_check(), its much easier to trigger this since we
> test for a number of locks and we only need to hold any one of them to
> be good.
> 
> Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/1312547787.28695.2.camel@twins

BTW, I can't open this link.

Thanks,
Yong

