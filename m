Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1LTU3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 15:29:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43230 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1LTU27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 15:28:59 -0500
Date: Tue, 20 Dec 2011 12:28:54 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
Message-ID: <20111220202854.GH10752@google.com>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
 <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
 <20111220162315.GC10752@google.com>
 <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Tue, Dec 20, 2011 at 11:28:25AM -0800, Linus Torvalds wrote:
> > Description for 7340a0b152 "this_cpu: Introduce this_cpu_ptr() and
> > generic this_cpu_* operations" should explain the above three.
> 
> I don't think that's relevant.
> 
> Sure, they have semantics, but the semantics are stupid and wrong.
> Whether they are documented or not isn't even the issue.

I was trying to point Pekka to documentation so that at least the
existing semantics are clear.

> Being "generic" is not actually a good thing. Not when we're talking
> about random details like this.

Yeah, I generally agree that reducing the API would be great.  Given
the usage, I think (or at least hope) dropping preemption protected
ones wouldn't hurt much but it might be worthwhile to keep
__this_cpu_*() - the ones which expect the caller to take care of
synchronization - w/ assertion on irq disabled.

Christoph, what do you think?  What would be the minimal set that you
can work with?

Thanks.

-- 
tejun
