Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822Ab2GDKNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:13:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37258 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2GDKNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:13:07 -0400
Subject: Re: [PATCH -mm v2 01/11] mm: track free size between VMAs in VMA
 rbtree
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hannes@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org
In-Reply-To: <CANN689HchF15SfZKo6i9yD7k7NnSECm-7+wMq2EfjoyoCV7vaA@mail.gmail.com>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
	 <1340315835-28571-2-git-send-email-riel@surriel.com>
	 <20120629234638.GA27797@google.com> <4FF3662A.9070700@redhat.com>
	 <CANN689HchF15SfZKo6i9yD7k7NnSECm-7+wMq2EfjoyoCV7vaA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 12:12:53 +0200
Message-ID: <1341396773.2507.79.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 16:16 -0700, Michel Lespinasse wrote:
> On Tue, Jul 3, 2012 at 2:37 PM, Rik van Riel <riel@redhat.com> wrote:
> > On 06/29/2012 07:46 PM, Michel Lespinasse wrote:
> >> Basically, I think lib/rbtree.c should provide augmented rbtree support
> >> in the form of (versions of) rb_insert_color() and rb_erase() being able
> >> to
> >> callback to adjust the augmented node information around tree rotations,
> >> instead of using (conservative, overkill) loops to adjust the augmented
> >> node information after the fact
> >
> > That is what I originally worked on.
> >
> > I threw out that code after people told me (at LSF/MM) in
> > no uncertain terms that I should use the augmented rbtree
> > code :)
> 
> Well, bummer. Could you summarize what their argument was ? In other
> words, what are the constraints besides not adding overhead to the
> scheduler rbtree use case and keeping the code size reasonable ?

Mostly those.. but if you can do the thing with the __always_inline and
__flatten stuff from Daniel I'm ok with GCC generating more code, as
long we don't don't have to replicate the RB tree logic in C.

