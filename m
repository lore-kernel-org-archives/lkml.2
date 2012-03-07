Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967Ab2CGUZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:25:21 -0500
Received: from mail.windriver.com ([147.11.1.11]:52424 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab2CGUZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:25:16 -0500
Date: Wed, 7 Mar 2012 14:24:39 -0600
From: Peter Seebach <peter.seebach@windriver.com>
To: Nick Bowler <nbowler@elliptictech.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Anton Blanchard <anton@samba.org>, <paulus@samba.org>,
        <peterz@infradead.org>, <mingo@elte.hu>, <dsahern@gmail.com>,
        <fweisbec@gmail.com>, <yanmin_zhang@linux.intel.com>,
        <emunson@mgebm.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Incorrect use of snprintf results in SEGV
Message-ID: <20120307142439.2fc4e96c@wrlaptop>
In-Reply-To: <20120307184455.GA13565@elliptictech.com>
References: <20120307114249.44275ca3@kryten>
	<20120307010904.GE5656@infradead.org>
	<20120306192912.59811e3e@wrlaptop>
	<20120307184455.GA13565@elliptictech.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012 13:44:55 -0500
Nick Bowler <nbowler@elliptictech.com> wrote:

> To answer the question, one "solution" here is to run in a loop
> allocating larger and larger buffers until ret is strictly less
> than len, then (for this function) free the allocated buffer.

Strictly speaking, I am obliged to concede that this does, in fact,
result in either success or knowledge that success is impossible in a
finite number of iterations.  However, the number-of-iterations vs.
wasted-space tradeoff is horrible.  I appreciate the use of scare
quotes around the word "solution".  :)

> There are a couple functions in POSIX that work this way (*cough*
> readlink *cough*), and it's *ugly*.

The other thing we looked at, I believe, was Microsoft's sprintf_s(),
which is the "secure" version.  I can't honestly say from reading their
docs whether "ran out of space" is an error (resulting in returning -1)
or whether it returns the number of bytes written.  Either way, it has
that same basic problem.  Also there's strftime(), which has the
brilliant design choice that if it runs out of space, it returns a
value which could in fact be a correct return value for at least some
possible inputs, and the contents of the buffer are indeterminate.  A
true feat of software engineering, that.

-s
-- 
Listen, get this.  Nobody with a good compiler needs to be justified.
