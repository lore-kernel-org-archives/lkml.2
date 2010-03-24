Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0CXWXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:23:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38675 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab0CXWXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:23:38 -0400
Date: Wed, 24 Mar 2010 23:23:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Message-ID: <20100324222324.GA31154@elte.hu>
References: <201003242240.54907.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003242240.54907.arnd@arndb.de>
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


* Arnd Bergmann <arnd@arndb.de> wrote:

> I've built-tested an allmodconfig kernel with CONFIG_BKL disabled on x86_64, 
> i386, powerpc64, powerpc32, s390 and arm to make sure I catch all the 
> modules that depend on BKL, and I've been running various versions of this 
> tree on my desktop machine over the last few weeks while adding stuff.

Very nice work!

How about going one step further:

 - remove CONFIG_BKL altogether
 - remove all the remains of the BKL code in lib/kernel_lock.c and kernel/sched.c
 - turn lock_kernel() into a WARN_ONCE() and unlock_kernel() into a NOP.
 - ...
 - Celebrate! :-)

	Ingo
