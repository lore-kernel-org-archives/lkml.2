Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab1EPQIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:08:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51486 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547Ab1EPQIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:08:11 -0400
Date: Mon, 16 May 2011 18:08:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
        Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/5] Add a sysconf syscall
Message-ID: <20110516160810.GB25898@one.firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org> <1305329059-2017-5-git-send-email-andi@firstfloor.org> <20110514065752.GA8827@elte.hu> <20110514163424.GU6008@one.firstfloor.org> <4DD14814.8080305@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD14814.8080305@mit.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You could also add a vsyscall function and have that function pull the 
> values from vvar data.  It would be very fast (i.e. almost as fast as 
> mmaping some data) and it would be more portable.

vvar is a global. The variable data in sysconf is per thread
(and not even per mm)

Even if you ignore the semantic problem of thread versus mm, you would
need a new writable page per process and update it any time
the rlimits and other information is updated.

On the other hand my solution is dead simple and already solves
the problem.

-Andi
