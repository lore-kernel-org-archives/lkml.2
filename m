Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab0KAMIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 08:08:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755719Ab0KAMIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 08:08:50 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Nov 2010 08:07:50 -0400
Message-ID: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>
Subject: Linux 2.6.37-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The merge window for 2.6.37 is over, and -rc1 is out there (or will be
soon, as things are uploading from my laptop here in Boston and then
mirroring out)

There's a lot of changes there - just shy of 10k commits since 2.6.36
- despite the slightly shortened merge window. Way too many to list.
But the part that I think deserves some extra mention is that we've
finally largely gotten rid of the BKL (big kernel lock) in all the
core stuff, and you can easily compile a kernel without any BKL
support at all. It's been a long road, and thanks to Arnd and others
who did it.

Note that "core code" does not mean "everything". There are still
drivers out there that need the BKL, and if you configure the kernel
without it, you won't be able to configure in the V4L drivers, for
example. They still have lock_kernel/unlock_kernel calls in them, but
hopefully that will get fixed too, to the point where in the not too
distant future we will hopefully see only some legacy drivers that
nobody uses needing the old locking.

Other than that, it looks like a fairly normal release. Lots of
changes all over, with drivers - as usual - dominating the patches.
Give it all a try, and hopefully this will be a quiet week wrt
development with lots of core developers here at the kernel summit.

                           Linus
