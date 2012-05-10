Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188Ab2EJMFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:05:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:54483 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab2EJMFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:05:42 -0400
Subject: Re: [PATCH] sched: set TAINT_UNSAFE_SMP after sleep-in-atomic bug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4FAB9EC0.8090905@openvz.org>
References: <20120510075403.21849.5109.stgit@zurg>
	 <1336644104.2527.93.camel@twins>  <4FAB9EC0.8090905@openvz.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 May 2012 13:46:38 +0200
Message-ID: <1336650398.27020.91.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 14:56 +0400, Konstantin Khlebnikov wrote:
> Peter Zijlstra wrote:
> > On Thu, 2012-05-10 at 11:54 +0400, Konstantin Khlebnikov wrote:
> >> Usually sleep-in-atomic bugs are followed by dozens other warnings.
> >> This patch should help to figure out original source of problem.
> >> This taint flag also turns off lockdep, because it can go mad after that.
> >
> > There's already TAINT_WARN any output with that set should be ignored.
> 
> Where? I do not see here anything which might set TAINT_WARN.
> 
> Or you suggest to use TAINT_WARN instead of TAINT_UNSAFE_SMP?

Gargh, yeah it doesn't use WARN and related infrastructure to print that
msg so it missed out on the whole TAINT_WARN stuff.

Yeah, make it set TAINT_WARN or possibly convert the thing to use WARN.

