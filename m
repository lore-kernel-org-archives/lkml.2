Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789Ab2D0Qx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:53:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54447 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758382Ab2D0Qx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:53:56 -0400
Date: Fri, 27 Apr 2012 17:53:06 +0100
From: Will Deacon <will.deacon@arm.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] asm-generic: io: remove {read,write} string functions
Message-ID: <20120427165306.GC14743@mudshark.cambridge.arm.com>
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com>
 <201204271217.50048.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204271217.50048.vapier@gentoo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Fri, Apr 27, 2012 at 05:17:47PM +0100, Mike Frysinger wrote:
> On Friday 27 April 2012 06:42:55 Will Deacon wrote:
> > The {read,write}s{b,w,l} functions are not defined across all
> > architectures and therefore shouldn't be used by portable drivers. We
> > should encourage driver writers to use the io{read,write}{8,16,32}_rep
> > functions instead.
> 
> well, that isn't true today as a grep of the drivers/ tree shows.  perhaps we 
> should fix that first ?  quite a number of architectures do implement these.

Sure, and architectures can continue to implement these if they're using
drivers that require them (I'll reintroduce them for blackfin). They
shouldn't be used for new architectures though, so any drivers that are
required by folks using asm-generic/io.h will need converting.

> > This patch removes the {read,write} string functions for the generic IO
> > header as they have no place in a new architecture port.
> 
> i don't see any file anywhere that describes what the baseline API is supposed 
> to be, and what each set of funcs are for.  there is just the random ugliness 
> in each arch's asm/io.h cobbled together until things work.  i think that also 
> needs to be addressed before we go extending/contracting the API provides by 
> asm-generic/io.h.

I agree that it's a bit of a mess, but if we can keep the asm-generic
interfaces clean then it can help driver writers see what we have as a
common base. If a driver is not portable (maybe for some
architecture-specific device) then they could use extra accessors if they
really need to.

The point of removing these functions is to make it clear that they're not
part of the baseline API and instead encourage people to use other accessors
instead if they want to write portable code.

Will
