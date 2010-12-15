Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab0LOKKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 05:10:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41591 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab0LOKKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 05:10:37 -0500
Date: Wed, 15 Dec 2010 10:10:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Thorsten Glaser <tg@mirbsd.de>,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        Greg Ungerer <gerg@snapgear.com>
Subject: Re: Signal patchset (was: Re: aranym bug, manifests as "ida_remove
 called for id=13" on recent kernels)
Message-ID: <20101215101027.GA31097@ZenIV.linux.org.uk>
References: <AANLkTi=9B-8KN0oiXoiU+KqPt6B8Vs=d7yu9cui-7e1r@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=9B-8KN0oiXoiU+KqPt6B8Vs=d7yu9cui-7e1r@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 05, 2010 at 12:15:10PM +0100, Geert Uytterhoeven wrote:

> Unless someone objects, I'm inclined to apply Al's patchset, as it improves the
> situation anyway.
> 
> OK?

FWIW, there's an m68knommu counterpart (ACKed by gerg a while ago).  The
entire bunch is on ftp.linux.org.uk/pub/people/viro/m68k-signals - both m68k
and m68knommu sets.  I don't know how you guys would prefer it done, since
there's a trivial dependency between m68k and m68knommu parts of series -
the former has
+#ifndef __uClinux__
+#define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#endif
in unistd.h and the latter does
-#ifndef __uClinux__
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
-#endif
Both parts switch to generic sys_rt_sigsuspend(), for mmu and nommu resp.,
so they need __ARCH_WANT_SYS_RT_SIGSUSPEND defined as soon as conversion
is done.  Other than that they are independent.
