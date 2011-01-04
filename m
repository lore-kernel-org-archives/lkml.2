Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab1ADPRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:17:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44735 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab1ADPRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:17:13 -0500
Date: Tue, 4 Jan 2011 16:16:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/18] sched: Reduce runqueue lock contention -v4
Message-ID: <20110104151656.GA339@elte.hu>
References: <20110104145929.772813816@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104145929.772813816@chello.nl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Latest version of the scary patches...

Just to make it easier for others to see the rationale behind this series, see the 
numbers and limitations listed below.

	Ingo

------------------------->
As measured using: http://oss.oracle.com/~mason/sembench.c

$ echo 4096 32000 64 128 > /proc/sys/kernel/sem
$ ./sembench -t 2048 -w 1900 -o 0

unpatched: run time 30 seconds 639476 worker burns per second
patched:   run time 30 seconds 847526 worker burns per second

Still need to sort out all the races marked XXX (non-trivial), and its
x86 only for the moment.

