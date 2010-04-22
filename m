Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab0DVQ2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:28:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:35739 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab0DVQ2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:28:10 -0400
Subject: Re: Considerations on sched APIs under RT patch
From: Peter Zijlstra <peterz@infradead.org>
To: Primiano Tucci <p.tucci@gmail.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>, Bjoern Brandenburg <bbb@email.unc.edu>
In-Reply-To: <k2gc5b2c05b1004220840z59f9417fy723a36a6fe9924dc@mail.gmail.com>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
	 <1271839772.1776.58.camel@laptop>
	 <1271854016.10448.172.camel@gandalf.stny.rr.com>
	 <x2mc5b2c05b1004211224s7825933dh531f2ed030610e9e@mail.gmail.com>
	 <1271879833.1776.186.camel@laptop>
	 <s2tc5b2c05b1004211338y814bc3b2o547a6eecdf64ca7f@mail.gmail.com>
	 <1271883496.1776.263.camel@laptop>
	 <1271942430.10448.196.camel@gandalf.stny.rr.com>
	 <x2hc5b2c05b1004220650w53919f62hf3daedb822755bf4@mail.gmail.com>
	 <1271944622.1776.349.camel@laptop>
	 <k2gc5b2c05b1004220840z59f9417fy723a36a6fe9924dc@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Apr 2010 18:28:06 +0200
Message-ID: <1271953686.1776.372.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 17:40 +0200, Primiano Tucci wrote:

> > Its a well studied
> > algorithm and even available in commercial SMP operating systems
> 
> Can you cite me a commercial SMP system that supports
> multicore/multiprocessor G-EDF?

From: http://www.cs.unc.edu/~anderson/papers/rtlws09.pdf

"Regarding the frequently voiced objections to G-
EDF’s viability in a “real” system, it should be noted that
xnu, the kernel underlying Apple’s multimedia-friendly
OS X, has been relying on G-EDF to support real-time
applications on multiprocessors for several years [5]."

"[5] Apple Inc. xnu source code.
http://opensource.apple.com/source/xnu/."


> > Implementing this as userspace/middleware seems daft. But if your
> > controlling process has a global affinity mask and runs as the highest
> > available userspace process priority its still all valid.
> 
> It is how it is implemented now, and how it works under VXWorks!

But that does not, and can not, provide proper isolation and bandwidth
guarantees since there could be runnable tasks outside the scope of the
middleware.

