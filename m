Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0D0Phg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:37:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614Ab0D0Phe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:37:34 -0400
Date: Tue, 27 Apr 2010 08:36:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: John Kacur <jkacur@redhat.com>
cc: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/7] logfs: push down BKL into ioctl function
In-Reply-To: <alpine.LFD.2.00.1004271725490.3318@localhost>
Message-ID: <alpine.LFD.2.00.1004270833530.3739@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004271359180.3318@localhost> <1272378265-10909-2-git-send-email-arnd@arndb.de> <20100427145804.GA16794@logfs.org> <201004271705.50499.arnd@arndb.de> <20100427150919.GB16794@logfs.org>
 <alpine.LFD.2.00.1004271725490.3318@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Apr 2010, John Kacur wrote:
>
> You can ask Linus whether he'll take a convert unlocked_ioctl now or not.

Absolutely not.

I could imagine merging something like just the bkl_ioctl rename: if it 
breaks, it won't compile, so there is little risk, and _if_ it helps the 
next merge window I could merge it early.

But it looks like people are trying to avoid it entirely, and there is not 
a way in *hell* I will take some big and scary "push BKL down" patch that 
is clearly _not_ 99% mechanical and clearly _can_ introduce major and 
subtle bugs while compiling. 

			Linus
