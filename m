Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab1E2Anm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 20:43:42 -0400
Received: from smtp-out.google.com ([74.125.121.67]:49853 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab1E2Anl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 20:43:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=xYPwY0C/pB3oU1zaET0htPp7naeF2n6ZajATOeLzaKipj3fvmL8BqWNQv4Q6AV/4PV
         UBYaywcx3gyXDlRlnVDQ==
Date: Sat, 28 May 2011 17:43:27 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix page_lock_anon_vma leaving mutex locked
In-Reply-To: <BANLkTi=9qqiLNuo9qbcLoQtK3CKSPnhn4g@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1105281738530.14374@sister.anvils>
References: <alpine.LSU.2.00.1105281317090.13319@sister.anvils> <1306617270.2497.516.camel@laptop> <alpine.LSU.2.00.1105281437320.13942@sister.anvils> <BANLkTinsq-XJGvRVmBa6kRp0RTj9NqGWtA@mail.gmail.com> <alpine.LSU.2.00.1105281634440.14257@sister.anvils>
 <BANLkTi=9qqiLNuo9qbcLoQtK3CKSPnhn4g@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 May 2011, Linus Torvalds wrote:
> On Sat, May 28, 2011 at 5:12 PM, Hugh Dickins <hughd@google.com> wrote:
> >
> > Though I think I'm arriving at the conclusion that this patch
> > is correct as is, despite the doubts that have arisen.
> 
> Well, you hopefully saw my second email where I had come to the same conclusion.

Yes, thanks.

> 
> So I applied the third patch as well, after all. I think it's at the
> very least at least "more correct" than what we have now. Whether that
> "page_mapped()" should then be extended to do something else is an
> additional thing, and I suspect it would affect the slow-path case
> too.

Yes, I agree it's certainly more correct (two machines running well
with it for 33 hours now, one of them would hang in 7 or 17 hours).

And I'm increasingly confident that it's complete too, but it will be
interesting to see whether I've persuaded Peter.  It was certainly a
very good point that he raised, that I hadn't thought of at all.

Hugh
