Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab0DKU4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 16:56:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33845 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab0DKU4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 16:56:42 -0400
To: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: setitimer vs. threads: SIGALRM returned to which thread? (process master or individual child)
From: Andi Kleen <andi@firstfloor.org>
References: <4BBFA0C6.2610.2C4FFE@Frantisek.Rysanek.post.cz>
Date: Sun, 11 Apr 2010 22:56:39 +0200
In-Reply-To: <4BBFA0C6.2610.2C4FFE@Frantisek.Rysanek.post.cz> (Frantisek Rysanek's message of "Fri, 09 Apr 2010 21:48:54 +0200")
Message-ID: <87d3y5btdk.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Frantisek Rysanek" <Frantisek.Rysanek@post.cz> writes:

> Yes, it used to be quite a relief to have Linux do the management of 
> timers for me. Now I have two options to choose from:
> 1) write my own "timer queueing" (timekeeping) code to order the 
> timers for me in the master thread
> 2) find another function, similar to setitimer(), that would function 
> the way setitimer() used to work in the old days...

POSIX timers (timer_create et.al.) allow specifying the signal.

So if you use custom RT signals for each threads and block them in the
threads you don't want them it should work. This would limit the
maximum number of threads though because there's only a limited
range of RT signals.

There are probably other ways to do this too, e.g. with some clever
use of timerfd_create in recent kernels.

Or you could overwrite the clone in the thread library to not 
set signal sharing semantics. This might have other bad side effects
though.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
