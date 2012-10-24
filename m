Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565Ab2JXTiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:38:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab2JXTio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:38:44 -0400
Date: Wed, 24 Oct 2012 12:38:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20121024123842.bcb6af93.akpm@linux-foundation.org>
In-Reply-To: <1351106379.24165.13.camel@joe-AO722>
References: <20121023144221.5ae3061a11766df8175b959d@canb.auug.org.au>
	<20121023124414.61568323.akpm@linux-foundation.org>
	<1351021889.7502.55.camel@joe-AO722>
	<20121023130234.827aa5df.akpm@linux-foundation.org>
	<1351106379.24165.13.camel@joe-AO722>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012 12:19:39 -0700
Joe Perches <joe@perches.com> wrote:

> On Tue, 2012-10-23 at 13:02 -0700, Andrew Morton wrote:
> > On Tue, 23 Oct 2012 12:51:29 -0700
> > Joe Perches <joe@perches.com> wrote:
> > 
> > > > btw, what's up with printk_syslog.h?  It includes two header files which it
> > > > doesn't need but fails to include the two it *does* need: printk_log.h
> > > > and types.h.
> > > > 
> > > > 
> > > 
> > > printk_syslog.c includes kernel.h (it includes types.h)
> > > and printk_log.h.
> > > 
> > > I think printk_syslog.h doesn't need printk_log.h
> > 
> > A general rule is that the header file shouldn't know or care what else
> > it's includer has included.  Ideally it shouldn't know or care what
> > else its includees have included, either.
> > 
> > A fun test would be
> > 
> > for i in *.h
> > 	echo $i > foo.c
> > 	make foo.o
> > done
> 
> A whole lot of things in include/ fail this.

I bet.

> Do you really think that anything using u8/16/32/64
> should include types.h?

Well, yes.  If someone writes a C file which includes such a header as
fisst-included then OK, it will fail and they'll fix things up.  But
where the problems occur is when that file is *not* the first-included,
but they happened to get types.h via another Kconfig-dependent include.
Later, the build explodes for someone else.  The only reliable way of
avoiding this is for each file to include its dependencies.

I don't think it's worth going off and trying to "fix" all of this
though.  Such an exercise has its own risks and this problem just isn't
that big - it happens often enough, but it's very easy to fix.


