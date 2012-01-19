Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab2ASM2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 07:28:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52747 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2ASM2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 07:28:37 -0500
MIME-Version: 1.0
In-Reply-To: <1326958401.1113.22.camel@edumazet-laptop>
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils>
	<1326958401.1113.22.camel@edumazet-laptop>
Date: Thu, 19 Jan 2012 04:28:35 -0800
X-Google-Sender-Auth: 8-w1PWyfG1JQYGqXSTFsZfa-Zjc
Message-ID: <CAOS58YO585NYMLtmJv3f9vVdadFqoWF+Y5vZ6Va=2qHELuePJA@mail.gmail.com>
Subject: Re: [PATCH] memcg: restore ss->id_lock to spinlock, using RCU for next
From: Tejun Heo <tj@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 18, 2012 at 11:33 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Interesting, but should be a patch on its own.

Yeap, agreed.

> Maybe other idr users can benefit from your idea as well, if patch is
> labeled  "idr: allow idr_get_next() from rcu_read_lock" or something...
>
> I suggest introducing idr_get_next_rcu() helper to make the check about
> rcu cleaner.
>
> idr_get_next_rcu(...)
> {
>        WARN_ON_ONCE(!rcu_read_lock_held());
>        return idr_get_next(...);
> }

Hmmm... I don't know. Does having a separate set of interface help
much?  It's easy to avoid/miss the test by using the other one.  If we
really worry about it, maybe indicating which locking is to be used
during init is better? We can remember the lockdep map and trigger
WARN_ON_ONCE() if neither the lock or RCU read lock is held.

Thanks.

-- 
tejun
