Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab1BNPjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:39:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab1BNPjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:39:11 -0500
Date: Mon, 14 Feb 2011 10:38:44 -0500
From: David Teigland <teigland@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] dlm fix for 2.6.38
Message-ID: <20110214153844.GA6909@redhat.com>
References: <20110211233844.GC30276@redhat.com>
 <1297525475.2584.1.camel@dolmen>
 <20110212155100.GR3770@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110212155100.GR3770@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 04:51:00PM +0100, Tejun Heo wrote:
> On Sat, Feb 12, 2011 at 03:44:35PM +0000, Steven Whitehouse wrote:
> > What is the issue here? If there is a problem with the workqueues then
> > we should ask Tejun about it,
>
> Yeah, what kind of problem was it?  There's only one work per
> connection so reordering is not a problem.  All the workqueue
> operations use proper locking, so the conversion seemed safe to me.
> What am I missing?

find_lkb seems to be getting an actual, but wrong lkid, so it's returning
the wrong lkb in the receive routines.  It happens fairly quickly with
multiple wq threads, but not at all with single.  One suspect I'm going to
look at are the ls_stub and fields in the lockspace struct.  I'm not
convinced extra send/recv threads give us that much benefit in practice,
so it's not my top priority at the moment.

Dave

