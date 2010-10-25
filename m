Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab0JYNSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 09:18:42 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53506 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751228Ab0JYNSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 09:18:40 -0400
Date: Mon, 25 Oct 2010 15:18:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: James Morris <jmorris@namei.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Kyle McMartin <kyle@mcmartin.ca>, kernel@lists.fedoraproject.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Serge Hallyn <serue@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
Message-ID: <20101025131829.GD2162@ucw.cz>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
 <20101017004945.GE1614@infradead.org>
 <20101017054008.GA16383@elte.hu>
 <20101017184652.GB28060@infradead.org>
 <alpine.LRH.2.00.1010181127480.9476@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1010181127480.9476@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Especially as our merge requirements for security/ are a lot lower than
> > for the rest of the kernel given that James is very afraid of getting
> > whacked by Linux for not mering things.
> 
> I think historically you'll see that I'm not afraid of getting whacked by 
> Linus.
> 
> A procedure for merging security features has been adopted by consensus, 
> based on suggestions from Arjan, with the aim of preventing the literally 
> endless arguments which arise from security feature discussions.  It's 
> sometimes referred to as the Arjan protocol, essentially:
> 
>   If the feature correctly implements a well-defined security goal, meets 
>   user needs without incurring unreasonable overheads, passes technical 
>   review, and is supported by competent developers, then it is likely to 
>   be merged.
> 
> If you disagree with a specific feature, you need to step up while it's 
> being reviewed and make a case against it according to the above
> criteria.

Well, I'm arguing that the criteria are wrong. Duplicated crap is
creeping in (TOMOYO vs. AppArmor), and strange stuff that has no
legitimate use is in (IMA -- what is it good for? locking machines
down, iPhone style).

> If you disagree with the protocol, then you need to come up with a better 
> one, and probably implement it yourself, to the satisfaction of all 
> parties.

I do disagree, and I do not think 'satistfaction of all parties' is
reasonable goal. Rest of kernel has different rules, and IMO they are better.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
