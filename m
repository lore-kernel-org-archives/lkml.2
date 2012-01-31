Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab2AaNbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:31:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:51633 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2AaNbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:31:03 -0500
Date: Tue, 31 Jan 2012 05:32:36 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, arjanvandeven@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: x86: clean up smpboot.c's use of udelay+schedule
Message-ID: <20120131053236.3f120f11@infradead.org>
In-Reply-To: <20120131124341.GC4408@elte.hu>
References: <20120130205304.0e10b05e@infradead.org>
	<20120131124341.GC4408@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 13:43:41 +0100
Ingo Molnar <mingo@elte.hu> wrote:
> > +			usleep_range(100, 200);
> 
> I'm wondering whether we could shorten this delay to say 10 
> usecs and thus save 0.1 msecs (or more) from a typical SMP 
> bootup?

doesn't matter really; bringing up a cpu is several orders more
expensive (> 100msec in 3.2, in 3.3 this got optimized to maybe 30 msec)
0.1 msec is the least of anyone's worries at this point ;-)

(would be nice if this was a completion, but this is rather fragile
code in general... at least not making it spin is an incremental
improvement)

