Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998Ab2JXTTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:19:49 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59637 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757994Ab2JXTTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:19:39 -0400
Message-ID: <1351106379.24165.13.camel@joe-AO722>
Subject: Re: linux-next: build failure after merge of the akpm tree
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Date: Wed, 24 Oct 2012 12:19:39 -0700
In-Reply-To: <20121023130234.827aa5df.akpm@linux-foundation.org>
References: <20121023144221.5ae3061a11766df8175b959d@canb.auug.org.au>
	 <20121023124414.61568323.akpm@linux-foundation.org>
	 <1351021889.7502.55.camel@joe-AO722>
	 <20121023130234.827aa5df.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 13:02 -0700, Andrew Morton wrote:
> On Tue, 23 Oct 2012 12:51:29 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > > btw, what's up with printk_syslog.h?  It includes two header files which it
> > > doesn't need but fails to include the two it *does* need: printk_log.h
> > > and types.h.
> > > 
> > > 
> > 
> > printk_syslog.c includes kernel.h (it includes types.h)
> > and printk_log.h.
> > 
> > I think printk_syslog.h doesn't need printk_log.h
> 
> A general rule is that the header file shouldn't know or care what else
> it's includer has included.  Ideally it shouldn't know or care what
> else its includees have included, either.
> 
> A fun test would be
> 
> for i in *.h
> 	echo $i > foo.c
> 	make foo.o
> done

A whole lot of things in include/ fail this.

Do you really think that anything using u8/16/32/64
should include types.h?


