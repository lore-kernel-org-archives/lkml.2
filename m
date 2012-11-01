Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935195Ab2KALnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 07:43:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35072 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147Ab2KALnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:43:04 -0400
Date: Thu, 1 Nov 2012 12:43:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        Adil Mujeeb <mujeeb.adil@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] checkpatch: Emit a warning when decimal values are
 used
Message-ID: <20121101114301.GB32532@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>, Joe Perches <joe@perches.com>,
	Andy Whitcroft <apw@canonical.com>,
	Adil Mujeeb <mujeeb.adil@gmail.com>, linux-kernel@vger.kernel.org
References: <cover.1351578285.git.joe@perches.com>
 <497a03b1726dda76e0fd49d5ea8d3514da2d0128.1351578285.git.joe@perches.com>
 <20121031103703.GA12648@elf.ucw.cz>
 <20121031154908.5a1921eb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121031154908.5a1921eb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 03:49:08PM -0700, Andrew Morton wrote:
> Joe means floating point.  I suggest that the patchset be reworked,
> using s/decimal/float/g.
> 
> 
> The kernel does have floating point constants, in various graphics
> drivers, iirc.  They are used in places where the floatiness gets
> handled at complation time.  Along the lines of:
> 
> 	int foo = 1.1 * 2.2;
> 
> And I suppose that's an OK thing to do.  We could instead do
> 
> 	int foo = 2;	/* 1.1 * 2.2 */
> 
> but that's taking away a programmer convenience for no good reason. 
> It would be highly inconvenient if the "1.1" was in fact a #define in
> some other file, or a Kconfig string.
> 
> 
> 
> That being said, I guess it's a worthwhile thing for checkpatch to warn
> about.  Hopefully the programmer will say "well thanks, but I meant to
> do that".
> 
> A much better solution would be to arrange for the kernel to fail to
> compile (or to fail to link) if floats are used.  That way, people
> could continue to use floats within their compile-time scalar
> expressions without getting harrassed by checkpatch.  But I don't know
> how to arrange this.

Run git grep on the source before compiling... Expensive though.

Also, Joe, I think you should add Andrew's explanation to the commit
message so that it is clear what that check is for. Or maybe even as a
comment above the check itself in checkpatch.pl.

Thanks.

-- 
Regards/Gruss,
    Boris.
