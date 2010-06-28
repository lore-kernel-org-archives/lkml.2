Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0F1XsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 19:48:14 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45574 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab0F1XsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 19:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CNhOXiik5VHS0xlSGTrfMcJzFc7HUn6oj1OHr1+QpyfcV8nFd0hce/jQcVPL1kUoNY
         XuSvk120PN1J8pqbExtILAwzOtpS2ULS7LPVKiX2AmHNRCA3zSmW5+NA3dV04BxshOSs
         iGLMk6S+ZlKykaX4PHBZv94dEk/0PlCfTauaQ=
MIME-Version: 1.0
In-Reply-To: <1277733320.3561.50.camel@laptop>
References: <AANLkTilJDrpoFGyTSrKg3Hg59u9TvBLbxk4HAVKBvjxQ@mail.gmail.com>
	<1277733320.3561.50.camel@laptop>
Date: Tue, 29 Jun 2010 07:48:12 +0800
Message-ID: <AANLkTinuas0MPFvZk9nOd91PuHXtaluHkkcWjGKYPZOl@mail.gmail.com>
Subject: Re: [PATCH] avoid return NULL on root rb_node in rb_next/rb_prev in 
	lib/rbtree.c
From: shenghui <crosslonelyover@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, linux-mm@kvack.org, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/28 Peter Zijlstra <peterz@infradead.org>:
> So if ->rb_leftmost is NULL, then the if (!left) check in
> __pick_next_entity() would return null.
>
> As to the NULL deref in in pick_next_task_fair()->set_next_entity() that
> should never happen because pick_next_task_fair() will bail
> on !->nr_running.
>
> Furthermore, you've failed to mention what kernel version you're looking
> at.
>

The kernel version is 2.6.35-rc3, and 2.6.34 has the same code.

For nr->running, if current is the only process in the run queue, then
nr->running would not be zero.
1784        if (!cfs_rq->nr_running)
1785                return NULL;
pick_next_task_fair() could pass above check and run to following:
1787        do {
1788                se = pick_next_entity(cfs_rq);
1789                set_next_entity(cfs_rq, se);
1790                cfs_rq = group_cfs_rq(se);
1791        } while (cfs_rq);

Then pick_next_entity will get NULL for current is the root rb_node.
Then set_next_entity would fail on NULL deference.



-- 


Thanks and Best Regards,
shenghui
