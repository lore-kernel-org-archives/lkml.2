Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2HNPS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:18:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:59724 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab2HNPS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:18:26 -0400
Date: Tue, 14 Aug 2012 17:18:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <efault@gmx.de>
cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [rfc patch] fs,reiserfs: unlock superblock before callling
 reiserfs_quota_on_mount()
In-Reply-To: <1344956189.5477.1.camel@marge.simpson.net>
Message-ID: <alpine.LFD.2.02.1208141717570.32033@ionos>
References: <1344949583.14924.36.camel@marge.simpson.net>  <1344954183.6724.8.camel@gandalf.stny.rr.com>  <1344955168.14924.85.camel@marge.simpson.net> <1344956189.5477.1.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012, Mike Galbraith wrote:

> On Tue, 2012-08-14 at 16:39 +0200, Mike Galbraith wrote: 
> > On Tue, 2012-08-14 at 10:23 -0400, Steven Rostedt wrote: 
> > > On Tue, 2012-08-14 at 15:06 +0200, Mike Galbraith wrote:
> > > > Greetings,
> > > > 
> > > > Using openSUSE's "partitioner" gizmo to set up a reiserfs partition with
> > > > quotas and whatnot enabled rewarded me with a deadlock.
> > > 
> > > Is this just a -rt bug? Can't this deadlock also in mainline?
> > 
> > It didn't with a NOPREEMPT kernel the one time I tried it, which seemed
> > mighty odd when I stared at the rt deadlock.  I'll give it another go, I
> > likely just munged q/d NOPREEMPT test.
> 
> Nope, no screw-up.  Maybe it can deadlock, but it refused to do so.

Lockdep should tell you if it could ...
