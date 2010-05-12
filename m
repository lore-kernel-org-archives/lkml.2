Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab0ELKkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 06:40:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab0ELKkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 06:40:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1273634462-2672-2-git-send-email-walken@google.com>
References: <1273634462-2672-2-git-send-email-walken@google.com> <1273634462-2672-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 01/12] rwsem: test for no active locks in __rwsem_do_wake undo code
Date: Wed, 12 May 2010 11:39:18 +0100
Message-ID: <27596.1273660758@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> If there are no active threasd using a semaphore, it is always correct to
> unqueue blocked threads. This seems to be what was intended in the undo code.
> 
> What was done instead, was to look for a sem count of zero - this is an
> impossible situation, given that at least one thread is known to be queued
> on the semaphore. The code might be correct as written, but it's hard to
> reason about and it's not what was intended (otherwise the goto out would
> have been unconditional).
> 
> Go for checking the active count - the alternative is not worth the headache.

I think this is a definite bug fix, so I've sent it upstream in advance.

David
