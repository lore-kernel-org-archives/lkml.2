Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2HBA6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 20:58:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab2HBA57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 20:57:59 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: post 3.5, phantom signals.
References: <20120731191731.GB30493@redhat.com>
	<20120801151134.GA9333@redhat.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 01 Aug 2012 20:57:56 -0400
In-Reply-To: <20120801151134.GA9333@redhat.com> (Oleg Nesterov's message of "Wed, 1 Aug 2012 17:11:34 +0200")
Message-ID: <y0m7gtiun3f.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> [...]
> Well, not sure this will help... but if you can reproduce this,
> may be you can identify the sender of the wrong SIGHUP at least.
>
> 	cd /sys/kernel/debug/tracing/
> 	echo "sig==1" >> events/signal/signal_generate/filter
> 	echo 1 >> options/stacktrace
> 	echo 1 >> events/signal/signal_generate/enable
> 	cat trace_pipe > SIGHUP_TRACE

FWIW, just in case your ftrace subsystem is already busy, this
two-liner is equivalent:

# stap -o SIGHUP_TRACE -e 'probe kernel.trace("signal_generate")
                              { if ($sig==1) print_backtrace() }'

- FChE
