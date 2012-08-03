Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2HCAQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 20:16:27 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51192 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab2HCAQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 20:16:25 -0400
Date: Thu, 2 Aug 2012 17:15:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        tglx@linutronix.de, mingo@kernel.org, davej@redhat.com
Subject: Re: [PATCH 00/13] UAPI header file split
Message-ID: <20120803001530.GC8250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080300-9360-0000-0000-0000090AA89B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 10:56:37PM +0100, David Howells wrote:
> 
> Here's the second installment of patches from step 1 of my plan below to clean
> up the kernel header files and sort out the inclusion recursion problems.
> 
> Note that these patches will need regenerating if the header files they alter
> change before they're applied.  However, the disintegration is scripted, so
> that just takes a few minutes normally.
> 
> 
> ===================================
> BACKGROUND ON THE RECURSION PROBLEM
> ===================================
> 
> I occasionally run into a problem where I can't write an inline function in a
> header file because I need to access something from another header that
> includes this one.  Due to this, I end up writing it as a #define instead.
> 
> The problems are mainly due to inline functions.  If we split some headers
> (linux/sched.h being the biggest culprit) to separate the inline functions from
> the data structs (e.g. task_struct) then we could reduce the problems.  Other
> splits and rearrangements could help also.
> 
> Quite often it's a case of an inline function in header A wanting a struct[*]
> from header B, but header B already has an inline function that wants a struct
> from header A.
> 
> 	[*] or constant or whatever.
> 
> In the past someone tried to add a kernel-offsets file (an analogue to
> asm-offsets) to deal with the problems of dealing with both linux/rcupdate.h
> and linux/sched.h - each header needed to be included before the other.

Indeed, and later attempts to work around this problem using per-CPU
variables did not go well either.  This separation should allow
__rcu_read_lock() to be inlined for PREEMPT=y kernels, which would be
quite nice.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

