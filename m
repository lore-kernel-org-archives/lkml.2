Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab2AFK3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 05:29:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483Ab2AFK3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 05:29:45 -0500
Date: Fri, 6 Jan 2012 02:33:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
Message-Id: <20120106023358.76374f2c.akpm@linux-foundation.org>
In-Reply-To: <20120106100520.GA7962@elte.hu>
References: <20120104201800.GA2587@www.outflux.net>
	<20120105091704.GB3249@elte.hu>
	<CAGXu5jJ=D1pKCZ8=1-WGkm0witNEH9Ux01+1BJyZKC_DAX00aA@mail.gmail.com>
	<20120106073635.GC14188@elte.hu>
	<20120106012120.32c3f370.akpm@linux-foundation.org>
	<20120106094339.GA9990@elte.hu>
	<20120106015808.1655d1c9.akpm@linux-foundation.org>
	<20120106100520.GA7962@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jan 2012 11:05:20 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Maybe true for a general purpose computer, but someone who is 
> > making a single-purpose device such as a digital TV or a wifi 
> > router won't want it.
> 
> That's the case for 99% of the features and semantics we have: 
> by definition a single-purpose device uses only a small sub-set 
> of an infinite purpose OS, right?
> 
> Still we only modularize semantics out if they easily fit into 
> some existing plug-in/module concept, if the feature is arguably 
> oddball that a sizable portion of people want to disable, or if 
> it makes notable sense for size reasons. To me it looked 
> distinctly silly to complicate things for such a small piece of 
> code.

We're talking tens or hundreds of millions of machines for which the
patch is a straightforward speed and space regression.  Fixing this
needs just a little Kconfig twiddling and a #else clause.  We may as
well do it.

> I doubt Kees would mind modularizing it, but it would be nice to 
> get VFS maintainer feedback in the:
> 
>    { 'you are crazy, over my dead body' ... 'cool, merge it' }
> 
> continuous spectrum of possible answers.

Well yes.  We'll get there.

Alas, I've become rather slack in my maintainer patchbombing in the
past year or two.  It's just boring and depressing to spray patches at
maintainers and have 90% or more of them simply ignored.  I'm sitting
on 45 such patches at present so I suppose I should get off my tail and
do a respray.
