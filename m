Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab2DAGwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 02:52:44 -0400
Received: from 1wt.eu ([62.212.114.60]:64017 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab2DAGwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 02:52:41 -0400
Date: Sun, 1 Apr 2012 08:52:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86-32: A better system call mechanism
Message-ID: <20120401065235.GB27590@1wt.eu>
References: <201204010000.quickdontsayit@terminus.zytor.com> <20120401065019.GA27590@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120401065019.GA27590@1wt.eu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 08:50:19AM +0200, Willy Tarreau wrote:
> Hi Peter,
> 
> On Sun, Apr 01, 2012 at 12:00:00AM +0000, H. Peter Anvin wrote:
> > On x86-32, we currently use int $0x80 as the primary system call
> > mechanism.  Although there are some recent variants available on
> > certain hardware (sysenter, syscall) via the vdso, the primary system
> > call vector is still way up the interrupt vector table, which is
> > inefficient.
> > 
> > This patch adds a very small amount of code which permits the very
> > first vector to be used for system call.  That vector is #DE, divide
> > error, generally known as division by zero.
> 
> Looks like a clever trick, but beyond the beauty, what does it really
> save ? Code size is the same as aam 0 / div edx are both 2-byte long,
> just like int 0x80. Is the call less expensive ? And if so, how does
> it compare to vdso ?

Hmmm I think I just found the response in the Date header, time to get
some coffee :-)

Willy

