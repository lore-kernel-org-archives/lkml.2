Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab0ITTmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:42:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090Ab0ITTmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:42:46 -0400
Date: Mon, 20 Sep 2010 12:41:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [RFC][PATCH 2/2] kernel: extract thread types from
 task_struct::flags
Message-Id: <20100920124143.a28b4c91.akpm@linux-foundation.org>
In-Reply-To: <1285010716.2275.797.camel@laptop>
References: <20100920151334.569154707@chello.nl>
	<20100920151839.414197086@chello.nl>
	<20100920121446.18fb3a65.akpm@linux-foundation.org>
	<1285010716.2275.797.camel@laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 21:25:16 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> So can you agree with Linus' proposal of simply moving all type like
> bits over to a new word, or would you rather see the linear type field
> with an extra helper; possibly part of the existing ->flags field?

No strong feelings either way, really.

One thing we should keep an eye out for is the size/speed of code at
the client callsites.  Plucking a field of bits out of the flags word
and then treating that as a scalar would generate quite a bit of code,
I expect.  Let's not do that.
