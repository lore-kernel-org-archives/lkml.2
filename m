Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0I1Rgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:36:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab0I1Rge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:36:34 -0400
Date: Tue, 28 Sep 2010 13:36:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 4/4] blkio: Recalculate the throttled bio dispatch time
 upon throttle limit change
Message-ID: <20100928173625.GD8950@redhat.com>
References: <1285693859-13591-1-git-send-email-vgoyal@redhat.com>
 <1285693859-13591-5-git-send-email-vgoyal@redhat.com>
 <20100928101641.a2791513.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928101641.a2791513.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 10:16:41AM -0700, Randy Dunlap wrote:
> On Tue, 28 Sep 2010 13:10:59 -0400 Vivek Goyal wrote:
> 
> > o Currently any cgroup throttle limit changes are processed asynchronousy and
> >   the change does not take affect till a new bio is dispatched from same group.
> > 
> > o It might happen that a user sets a redicuously low limit on throttling.
> >   Say 1 bytes per second on reads. In such cases simple operations like mount
> >   a disk can wait for a very long time.
> > 
> > o Once bio is throttled, there is no easy way to come out of that wait even if
> >   user increases the read limit later.
> > 
> > o This patch fixes it. Now if a user changes the cgroup limits, we recalculate
> >   the bio dispatch time according to new limits.
> > 
> > o Can't take queueu lock under blkcg_lock, hence after the change I wake
> >   up the dispatch thread again which recalculates the time. So there are some
> >   variables being synchronized across two threads without lock and I had to
> >   make use of barriers. Hoping I have used barriers correctly. Any review of
> >   memory barrier code especially will help.
> 
> 
> Hi,
> Has this report been addressed/fixed?
> 

Hi Randy,

No. I was not aware of it. Thanks for bringing it to my notice. I will look
into it.

Vivek

> 
> on i386:
> 
> blk-throttle.c:(.text+0x1abb8): undefined reference to `__udivdi3'
> blk-throttle.c:(.text+0x1b1dc): undefined reference to `__udivdi3'
> 
> 
> on linux-next 2010-0924 and 2010-0927.
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
