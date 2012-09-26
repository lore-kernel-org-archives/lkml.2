Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2IZWnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 18:43:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab2IZWnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 18:43:46 -0400
Date: Wed, 26 Sep 2012 15:43:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: Daniel Santos <danielfsantos@att.net>,
        Michel Lespinasse <walken@google.com>, riel@redhat.com,
        peterz@infradead.org, aarcange@redhat.com, dwmw2@infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH v3 2/9] rbtree: add __rb_change_child() helper function
Message-Id: <20120926154345.52cb9f33.akpm@linux-foundation.org>
In-Reply-To: <506382E3.3020102@att.net>
References: <1345500331-10546-1-git-send-email-walken@google.com>
	<1345500331-10546-3-git-send-email-walken@google.com>
	<20120820151710.eeed9bcf.akpm@linux-foundation.org>
	<506382E3.3020102@att.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2012 17:34:11 -0500
Daniel Santos <danielfsantos@att.net> wrote:

> Sorry to resurrect the dead here, but I'm playing catch-up and this
> looks important.
> 
> On 08/20/2012 05:17 PM, Andrew Morton wrote:
> > I'm inclined to agree with Peter here - "inline" is now a vague,
> > pathetic and useless thing.  The problem is that the reader just
> > doesn't *know* whether or not the writer really wanted it to be
> > inlined.
> >
> > If we have carefully made a decision to inline a function, we should
> > (now) use __always_inline.
> Are we all aware here that __always_inline (a.k.a.
> "__attribute__((always_inline))") just means "inline even when not
> optimizing"?  This appears to be a very common misunderstanding (unless
> the gcc docs are wrong, see
> http://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html#index-g_t_0040code_007bflatten_007d-function-attribute-2512).
> 
> If you want to *force* gcc to inline a function (when inlining is
> enabled), you can currently only do it from the calling function by
> adding the |flatten attribute to it, which I have proposed adding here:
> https://lkml.org/lkml/2012/9/25/643.
> 
> Thus, all of the __always_inline markings we have in the kernel only
> affect unoptimized builds (and maybe -O1?).  If we need this feature
> (and I think it would be darned handy!) we'll have to work on gcc to get it.

When I replace the four __always_inline's in fs/namei.c with "inline",
namei.o's .text shrinks 2kbytes (gcc-4.4.4), so __always_inline does
allear to be doing what we think it does?


