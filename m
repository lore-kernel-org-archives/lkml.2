Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab2BCWOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 17:14:15 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40101 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757515Ab2BCWON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 17:14:13 -0500
Date: Fri, 3 Feb 2012 14:14:09 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 11/11] blkcg: unify blkg's for blkcg policies
Message-ID: <20120203221409.GF14209@google.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-12-git-send-email-tj@kernel.org>
 <20120202003730.GC19837@google.com>
 <20120203194105.GA12616@redhat.com>
 <20120203205910.GB14209@google.com>
 <20120203214435.GC12616@redhat.com>
 <20120203214719.GE14209@google.com>
 <20120203215349.GF9683@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203215349.GF9683@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 04:53:49PM -0500, Vivek Goyal wrote:
> Hmm... then blkiocg_reset_stats() will run into lock ordering issue. Can't
> hold queue lock inside blkcg lock. I guess you will do some kind of
> locking trick again as you did for io context logic.

Ummm... I don't know the details yet but decisions like making
policies per-queue are much higher level than locking details.  There
are cases where implementation details become problematic enough and
high level decisions are affected but I don't really think that would
be the case here.  It's not like reset stats is a hot path.  In fact,
I don't even understand why the hell we have it.  I guess it's another
blkcg braindamage.

If userland is interested in delta between certain periods, it's
supposed to read values at the start and end of the period and
subtract.  Allowing reset might make sense if there's single bearded
admin looking at the raw numbers, but it breaks as soon as tools and
automation are involved.  How would you decide who owns those
counters?

And we sadly can't even remove that at this point. Ugh................

-- 
tejun
