Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab2KDPvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 10:51:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114Ab2KDPvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 10:51:10 -0500
Date: Sun, 4 Nov 2012 16:52:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: George Spelvin <linux@horizon.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] percpu_rw_semaphore: reimplement to not block the
	readers unnecessarily
Message-ID: <20121104155204.GA30288@redhat.com>
References: <20121104084743.21804.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121104084743.21804.qmail@science.horizon.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04, George Spelvin wrote:
>
> Grand poo-bah Linus wrote:
> > Now, I doubt you'll find an architecture or C compiler where this will
> > actually ever make a difference, but the fact remains that you
> > shouldn't use signed integers for counters like this. You should use
> > unsigned, and you should rely on the well-defined modulo-2**n
> > semantics.
>
> Actually, this is another C standard undefined case that recent versions of
> GCC exploit for optimization.
                  ^^^^^^^^^^^^

This is another thing,

> For example, the loop:
> 	for (i = 1; i; i++)
> 		/* Code */
> will never terminate!  Feed the following to gcc -O2 and see for yourself:

Yes, because ...

> Notice the lack of test in the "jmp .L2" loop.

Exactly.

But if we have like

	int A, B;

	int sum(void)
	{
		return A + B;
	}

then I doubt there is any architecture (at least supported by linux)
which can generate the different code if you do s/int/unsigned/.


Anyway I agree, unsigned makes more sense, and I changed this patch
accordingly..

Oleg.

