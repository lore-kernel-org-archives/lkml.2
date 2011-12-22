Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1LVQIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:08:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33863 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab1LVQI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:08:28 -0500
Date: Thu, 22 Dec 2011 08:08:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
Message-ID: <20111222160822.GE17084@google.com>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
 <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
 <20111220162315.GC10752@google.com>
 <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
 <20111220202854.GH10752@google.com>
 <alpine.DEB.2.00.1112210851230.9601@router.home>
 <20111221170535.GB9213@google.com>
 <alpine.DEB.2.00.1112220854440.31315@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112220854440.31315@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Thu, Dec 22, 2011 at 08:58:43AM -0600, Christoph Lameter wrote:
> Well that would be a pretty nice simplification of the API.
> Replace the fallback code for the preempt safe ones with the
> irqsafe fallbacks, then drop the irqsafe variants from percpu.h.

Yeah, it seems we're going that direction.

> > > The way that the cmpxchg things are used is also similar to transactional
> > > memory that is becoming available in the next generation of processors by
> > > Intel and that is already available in the current generation of powerpc
> > > processors by IBM. It is a way to avoid locking overhead.
> >
> > Hmmm... how about removing the ones which aren't currently in use?
> 
> Yep. Could easily be done. We can resurrect the stuff as needed when other
> variants become necessary. In particular the _and and _or etc stuff was
> just added to be backward compatible with the old per cpu and local_t
> interfaces. There may be no use cases left.

Yeap, and that one too.  Maybe we can finally kill the duplicate
confusing static/dynamic accessors too.  I'm planning to get to it in
several weeks but if anyone can beat me to it, please go ahead.

Thank you.

-- 
tejun
