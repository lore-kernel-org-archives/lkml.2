Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab1HKNQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:16:23 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:45946 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab1HKNQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:16:22 -0400
Date: Thu, 11 Aug 2011 15:16:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, lueckintel@yahoo.com,
        kimwooyoung@gmail.com, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC v2] x86-64: Allow emulated vsyscalls from user addresses
Message-ID: <20110811131610.GA21916@ucw.cz>
References: <4E3C8B8A.3080007@zytor.com>
 <44eea096d708c5c3273e41ced354073ebd62a1d6.1312599769.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44eea096d708c5c3273e41ced354073ebd62a1d6.1312599769.git.luto@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> They trace control flow through the vsyscall page and recompile that
> code somewhere else.  Then they expect it to work.  DynamoRIO
> (http://dynamorio.org/) and Pin (http://www.pintool.org/) are
> affected.  They crash when tracing programs that use vsyscalls.
> Valgrind is smart enough not to cause problems.  It crashes on the
> getcpu vsyscall, but that has nothing to do with emulation.
> 
> This patch makes each of the three vsyscall entries use a different
> vector so that they can work when relocated.  It assumes that the
> code that relocates them is okay with the int instruction acting
> like ret.  DynamoRIO at least appears to work.

int acting as ret is seriously weird semantics. And no, invalid
syscall parameters will not cause segfault, just return of -EFAULT. So
... can this be changed?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
