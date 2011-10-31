Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab1JaKLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 06:11:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54610 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab1JaKLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 06:11:51 -0400
Date: Mon, 31 Oct 2011 10:11:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s3c2410: remove __ioaddrc()
Message-ID: <20111031101126.GE19187@n2100.arm.linux.org.uk>
References: <1319916749-14899-1-git-send-email-cesarb@cesarb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319916749-14899-1-git-send-email-cesarb@cesarb.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 05:32:29PM -0200, Cesar Eduardo Barros wrote:
> While looking at s3c2410's mach/io.h, I noticed the #define for
> __ioaddr() looked wrong. While the #defines above it called the "c"
> suffixed variant when __builtin_constant_p() was true, the one for
> __ioaddr() called the "c" suffixed variant (__ioaddrc()) when
> __builtin_constant_p() was *false*.
> 
> Looking further, I noticed that __ioaddr() and __ioaddrc() were
> identical, the only difference being that __ioaddr() is an inline
> function and __ioaddrc() is a macro.
> 
> __ioaddrc() is not used anywhere else. There were similar constructs,
> also reversed from what I'd expect, in both mach-clps7500 (removed from
> the kernel in 2.6.29) and mach-rpc. The copy in mach-rpc was removed in
> commit 6de2c31d3dad7384b3efa03674bd6ed479d58cb2 (rpc: remove obsolete IO
> accessors).
> 
> Since __ioaddrc() is both redundant and useless, has no other uses, and
> has already been removed in mach-rpc, remove it also in mach-s3c2410.

Good.  Now, what about that horrible fudge in the inb/outb etc accessors.
Can that be killed off as well?
