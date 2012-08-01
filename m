Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab2HAPOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:14:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427Ab2HAPOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:14:35 -0400
Date: Wed, 1 Aug 2012 17:11:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: post 3.5, phantom signals.
Message-ID: <20120801151134.GA9333@redhat.com>
References: <20120731191731.GB30493@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731191731.GB30493@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Dave Jones wrote:
>
> Since 3.5, I've started noticing weird things happening with signal delivery.
> Things I've seen so far..
>
> - long running tasks SIGINT, even though I wasn't even anywhere near the keyboard.
> - processes running inside screen/tmux disappearing (and taking the whole session with them).
>
> And now, while waiting for a kernel to build I just saw..
>
> /bin/sh: line 1:  3274 Hangup                  gcc

Currently I have no idea where this change could come from...

Well, not sure this will help... but if you can reproduce this,
may be you can identify the sender of the wrong SIGHUP at least.

	cd /sys/kernel/debug/tracing/
	echo "sig==1" >> events/signal/signal_generate/filter
	echo 1 >> options/stacktrace
	echo 1 >> events/signal/signal_generate/enable
	cat trace_pipe > SIGHUP_TRACE

and then rebuild the kernel.

Oleg.

