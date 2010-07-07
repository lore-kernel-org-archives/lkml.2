Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0GGUjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 16:39:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755544Ab0GGUjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 16:39:53 -0400
Date: Wed, 7 Jul 2010 13:38:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, xiaosuo@gmail.com,
       tim.gardner@canonical.com, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 0/3] splice fixes
Message-Id: <20100707133851.7c805c2d.akpm@linux-foundation.org>
In-Reply-To: <4C29E1A0.7070601@kernel.dk>
References: <E1OTYfk-0008GY-PJ@pomaz-ex.szeredi.hu>
	<4C29D5B9.9040401@kernel.dk>
	<E1OTZYn-0008Qk-El@pomaz-ex.szeredi.hu>
	<4C29E1A0.7070601@kernel.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jun 2010 14:05:52 +0200
Jens Axboe <axboe@kernel.dk> wrote:

> On 2010-06-29 14:05, Miklos Szeredi wrote:
> > On Tue, 29 Jun 2010, Jens Axboe wrote:
> >> On 2010-06-29 13:08, Miklos Szeredi wrote:
> >>> These patches fix bugs that affect real-world users of splice(2) and
> >>> sendfile(2) interfaces.
> >>>
> >>> Not sure if some or all of them are appropriate for 2.6.35 and/or
> >>> -stable?
> >>
> >> I think that 1-2 should go into 2.6.35 directly, and 3 for .36 with
> >> a stable backport as well. Agree?
> > 
> > Yes, sounds good.
> 
> Good, that is what I queued up. I haven't pushed out the updated
> for-linus yet, since I asked Linus to pull it this morning.
> 

According to Tim's report on lkml
(http://lkml.org/lkml/2010/6/25/280),
cc56f7de7f00d188c7c4da1e9861581853b9e92f caused a regression. 
cc56f7de7f00d188c7c4da1e9861581853b9e92f is present in 2.6.33 and in
2.6.34 hence the fix should be backported into -stable.

According to http://bugs.launchpad.net/bugs/588861, the patch "splice:
direct_splice_actor() should not use pos in sd" fixes the regression.

However this:

commit 4f9078afb4e083e033aafbbfabe729cb3832aa42
Author: Changli Gao <xiaosuo@gmail.com>
Date:   Tue Jun 29 13:09:18 2010 +0200

    splice: direct_splice_actor() should not use pos in sd

went into mainline without a cc:stable tag.
