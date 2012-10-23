Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566Ab2JWUCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:02:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab2JWUCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:02:35 -0400
Date: Tue, 23 Oct 2012 13:02:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20121023130234.827aa5df.akpm@linux-foundation.org>
In-Reply-To: <1351021889.7502.55.camel@joe-AO722>
References: <20121023144221.5ae3061a11766df8175b959d@canb.auug.org.au>
	<20121023124414.61568323.akpm@linux-foundation.org>
	<1351021889.7502.55.camel@joe-AO722>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 12:51:29 -0700
Joe Perches <joe@perches.com> wrote:

> > btw, what's up with printk_syslog.h?  It includes two header files which it
> > doesn't need but fails to include the two it *does* need: printk_log.h
> > and types.h.
> > 
> > 
> 
> printk_syslog.c includes kernel.h (it includes types.h)
> and printk_log.h.
> 
> I think printk_syslog.h doesn't need printk_log.h

A general rule is that the header file shouldn't know or care what else
it's includer has included.  Ideally it shouldn't know or care what
else its includees have included, either.

A fun test would be

for i in *.h
	echo $i > foo.c
	make foo.o
done


