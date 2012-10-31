Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075Ab2JaWtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:49:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760190Ab2JaWtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:49:10 -0400
Date: Wed, 31 Oct 2012 15:49:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        Adil Mujeeb <mujeeb.adil@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] checkpatch: Emit a warning when decimal values are
 used
Message-Id: <20121031154908.5a1921eb.akpm@linux-foundation.org>
In-Reply-To: <20121031103703.GA12648@elf.ucw.cz>
References: <cover.1351578285.git.joe@perches.com>
	<497a03b1726dda76e0fd49d5ea8d3514da2d0128.1351578285.git.joe@perches.com>
	<20121031103703.GA12648@elf.ucw.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012 11:37:03 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > Linux kernel doesn't like decimals, say so.
> 
> ?!
> 
> Linux surely supports decimal constants, like "100". Did you mean
> "octal"?
> 
> If you wanted to add warning for something... I never want to see
> 
> #define CRAPPY_EMBEDDED_REGISTER ((0x1) << (0))
> 
> again....

Joe means floating point.  I suggest that the patchset be reworked,
using s/decimal/float/g.


The kernel does have floating point constants, in various graphics
drivers, iirc.  They are used in places where the floatiness gets
handled at complation time.  Along the lines of:

	int foo = 1.1 * 2.2;

And I suppose that's an OK thing to do.  We could instead do

	int foo = 2;	/* 1.1 * 2.2 */

but that's taking away a programmer convenience for no good reason. 
It would be highly inconvenient if the "1.1" was in fact a #define in
some other file, or a Kconfig string.



That being said, I guess it's a worthwhile thing for checkpatch to warn
about.  Hopefully the programmer will say "well thanks, but I meant to
do that".

A much better solution would be to arrange for the kernel to fail to
compile (or to fail to link) if floats are used.  That way, people
could continue to use floats within their compile-time scalar
expressions without getting harrassed by checkpatch.  But I don't know
how to arrange this.

hm.
