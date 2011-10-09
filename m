Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab1JINpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 09:45:46 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:60413 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1JINpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 09:45:44 -0400
Date: Sun, 9 Oct 2011 16:45:40 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Lutomirski <luto@mit.edu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm00@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [3.1 patch] x86: default to vsyscall=native
Message-ID: <20111009134539.GC4586@localhost.pp.htv.fi>
References: <20111005214047.GE14406@localhost.pp.htv.fi>
 <alpine.LFD.2.02.1110052346080.18778@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1110052346080.18778@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 12:01:44AM +0200, Thomas Gleixner wrote:
>...
> We might need better dmesg output, e.g.
> 
>    printk_once("you might run something which requires
>    		vsyscall=native, but be aware that you are
> 		opening a security hole. See Documentation/....")
> 
> That's fine, but making the defaults insecure is just ass backwards.

Better dmesg output is in any case a better idea, patch is coming.

I stayed with warn_bad_vsyscall() instead of printk_once() for
the following reasons:
- _once is bad for something that might indicate exploit attempts,
  warn_bad_vsyscall() is already ratelimited
- the name and pid of the process should be shown
- the additional output of warn_bad_vsyscall() can help determine
  what caused it

> Thanks,
> 
> 	tglx

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

