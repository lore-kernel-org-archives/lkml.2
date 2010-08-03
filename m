Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0HCISe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:18:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52554 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab0HCISb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:18:31 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        npiggin@suse.de
Subject: Re: Linux 2.6.35
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
	<20100802023322.GA19164@dastard>
Date: Tue, 03 Aug 2010 10:18:30 +0200
In-Reply-To: <20100802023322.GA19164@dastard> (Dave Chinner's message of "Mon,
	2 Aug 2010 12:33:22 +1000")
Message-ID: <87tyncds89.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Sun, Aug 01, 2010 at 04:52:42PM -0700, Linus Torvalds wrote:
>> On a slightly happier note: one thing I do hope we can merge in the
>> upcoming merge window is Nick Piggin's cool VFS scalability series.
>> I've been using it on my own machine, and gone through all the commits
>> (not that I shouldn't go through some of them some more), and am
>> personally really excited about it. It's seldom we see major
>> performance improvements in core code that are quite that noticeable,
>> and Nick's whole RCU pathname lookup in particular just tickles me
>> pink.
>
> There hasn't been nearly enough review or testing of this patch
> series yet.  Before a merge, it needs to be split up in smaller,
> more digestable chunks for more comprehensive review, regression
> testing and behavioural analysis.

We started some testing of the VFS series on larger systems and so
far it looks all very good and the performance improvements are impressive
(but of course new bottlenecks are being exposed then)

The only snag found so far was that an ACL enabled file system
disables all the nice path walk improvements, so right now you
need to remount with noacl. I'm hoping this can be fixed
before a mainline release, otherwise I suspect it would disable
the improvements for lots of people (common distributions default
to acl on)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
