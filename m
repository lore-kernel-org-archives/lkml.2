Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab0DZWfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:35:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754907Ab0DZWfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:35:13 -0400
Date: Mon, 26 Apr 2010 15:32:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: David Miller <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       viro@zeniv.linux.org.uk, jblunck@suse.de, mingo@elte.hu,
       jkacur@redhat.com
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
In-Reply-To: <20100426220936.GB5695@nowhere>
Message-ID: <alpine.LFD.2.00.1004261525410.3739@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004251040340.3739@i5.linux-foundation.org> <201004261030.21751.arnd@arndb.de> <alpine.LFD.2.00.1004261104310.3739@i5.linux-foundation.org> <20100426.134207.229746269.davem@davemloft.net> <20100426220936.GB5695@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Apr 2010, Frederic Weisbecker wrote:
> 
> I've queued it for the next merge window in
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	bkl/ioctl

Btw, I hope you took the second version, that had the two additional fixes 
from Arnd (and my expansion of his fix to au1550_ac97.c).

Looking at the arch code, I doubt there are any big architecture-specific 
things. But there could easily be some other drivers like au1550_ac97.c 
that only get enabled on certain architectures and missed the grepping for 
some reason.

That said, because of Arnd's fix, I did end up grepping for 
'file_operations' and old-style gcc initializers (ie "ioctl: xyz" rather 
than the proper ".ioctl = xyz"), and the grep came up empty.

But it's possible that there's something hiding: with all of serial, 
bluetooth, block drivers, sound, socket proto's and v4l2 each having their 
own 'ioctl' pointers, it's not entirely trivial to grep for it all and be 
sure..

So there might be one or two cases still hiding, but it looks unlikely. 
And I'm almost certain that it definitely isn't more than just one or two.

		Linus
