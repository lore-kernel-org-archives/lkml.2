Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab2HAPue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:50:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab2HAPud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:50:33 -0400
Date: Wed, 1 Aug 2012 11:50:28 -0400
From: Dave Jones <davej@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: post 3.5, phantom signals.
Message-ID: <20120801155028.GA26424@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20120731191731.GB30493@redhat.com>
 <20120801151134.GA9333@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120801151134.GA9333@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 05:11:34PM +0200, Oleg Nesterov wrote:
 > On 07/31, Dave Jones wrote:
 > >
 > > Since 3.5, I've started noticing weird things happening with signal delivery.
 > > Things I've seen so far..
 > >
 > > - long running tasks SIGINT, even though I wasn't even anywhere near the keyboard.
 > > - processes running inside screen/tmux disappearing (and taking the whole session with them).
 > >
 > > And now, while waiting for a kernel to build I just saw..
 > >
 > > /bin/sh: line 1:  3274 Hangup                  gcc
 > 
 > Currently I have no idea where this change could come from...
 > 
 > Well, not sure this will help... but if you can reproduce this,
 > may be you can identify the sender of the wrong SIGHUP at least.
 > 
 > 	cd /sys/kernel/debug/tracing/
 > 	echo "sig==1" >> events/signal/signal_generate/filter
 > 	echo 1 >> options/stacktrace
 > 	echo 1 >> events/signal/signal_generate/enable
 > 	cat trace_pipe > SIGHUP_TRACE
 > 
 > and then rebuild the kernel.

I'll give that a shot when I'm back on running kernel of the day.
Right now, I'm bisecting something that requires an hour or so of testing
between each step, so that's pretty much written off this week.

	Dave

