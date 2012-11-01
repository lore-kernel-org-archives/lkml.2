Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab2KAJWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 05:22:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44133 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab2KAJWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 05:22:08 -0400
Date: Thu, 1 Nov 2012 10:22:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        Adil Mujeeb <mujeeb.adil@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] checkpatch: Emit a warning when decimal values are
 used
Message-ID: <20121101092204.GA11188@elf.ucw.cz>
References: <cover.1351578285.git.joe@perches.com>
 <497a03b1726dda76e0fd49d5ea8d3514da2d0128.1351578285.git.joe@perches.com>
 <20121031103703.GA12648@elf.ucw.cz>
 <20121031154908.5a1921eb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031154908.5a1921eb.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Linux kernel doesn't like decimals, say so.
> > 
> > ?!
> > 
> > Linux surely supports decimal constants, like "100". Did you mean
> > "octal"?
> > 
> > If you wanted to add warning for something... I never want to see
> > 
> > #define CRAPPY_EMBEDDED_REGISTER ((0x1) << (0))
> > 
> > again....
> 
> Joe means floating point.  I suggest that the patchset be reworked,
> using s/decimal/float/g.
> 
> 
> The kernel does have floating point constants, in various graphics
> drivers, iirc.  They are used in places where the floatiness gets
> handled at complation time.  Along the lines of:
> 
> 	int foo = 1.1 * 2.2;
....
> A much better solution would be to arrange for the kernel to fail to
> compile (or to fail to link) if floats are used.  That way, people
> could continue to use floats within their compile-time scalar
> expressions without getting harrassed by checkpatch.  But I don't know
> how to arrange this.

I know it is normally unwanted, but we do have kernel_fpu_begin(). I
thought it enables exactly... floating point math in kernel?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
