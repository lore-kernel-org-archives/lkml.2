Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1GYTtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 15:49:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327Ab1GYTtL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 15:49:11 -0400
MIME-Version: 1.0
In-Reply-To: <20110725190444.GA8302@elte.hu>
References: <20110722125236.GA24832@elte.hu> <CACqU3MUW81UmBK7qBQCZRqzfosrukYM9=o0EZP_DvSjgywfK8g@mail.gmail.com>
 <1311588599.2617.56.camel@laptop> <CA+55aFwxqVXb0cFrkgdrDH4J_aF9J7iw8i6ypAda2HiAyeFYpw@mail.gmail.com>
 <20110725190444.GA8302@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Jul 2011 12:48:48 -0700
Message-ID: <CA+55aFyDufcXR62j=crthVkNybk5is+c-zzr+LRmj_QSUskfmg@mail.gmail.com>
Subject: Re: [GIT PULL] core/locking changes for v3.1
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 12:04 PM, Ingo Molnar <mingo@elte.hu> wrote:
> ..
> net/netfilter/nf_conntrack_core.c: In function ‘nf_conntrack_init’:
> net/netfilter/nf_conntrack_core.c:1579:3: warning: the comparison
> will always evaluate as ‘true’ for the address of
> ‘nf_conntrack_attach’ will never be NULL [-Waddress]

These all seem to be essentially compiler bugs.

We have macros that do generic things (in this case
"rcu_assign_pointer()" and tests their values. The fact that the tests
sometimes end up being statically true (or false) is not something the
compiler should complain about - it should use it to optimize the
code.

Sad.

We can make a compiler bug-report, or disable -Waddress. Or maybe we
can write the tests in a way that doesn't trigger the compiler bug.

This same issue is why I hated -Wsign-compare. Some of the things gcc
complained about were just technically moronic. So compiler warnings
are not always a good thing.

                  Linus
