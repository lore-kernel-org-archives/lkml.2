Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab2IXSzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:55:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55856 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab2IXSzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:55:53 -0400
Date: Mon, 24 Sep 2012 22:55:46 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Mark Salter <msalter@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: sys_kcmp (was: Re: [PATCH 1/2] ARM: add finit_module syscall to
 ARM)
Message-ID: <20120924185546.GJ16532@moon>
References: <CAMuHMdXVKvaCoJTRb4O+Z4GuifzTEopdcRfRHBahQmpuX+Xi0w@mail.gmail.com>
 <20120922114549.GA11610@moon>
 <20120922132046.GA4260@flint.arm.linux.org.uk>
 <20120922114723.d7f07fb6.akpm@linux-foundation.org>
 <1348503709.20929.40.camel@deneb.redhat.com>
 <20120924164942.GH16532@moon>
 <20120924174256.GD24172@moon>
 <1348510573.20929.44.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348510573.20929.44.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 02:16:09PM -0400, Mark Salter wrote:
> > > >  #else
> > > > +#define mmap_min_addr          0UL
> > > >  #define dac_mmap_min_addr      0UL
> > > >  #endif
> > > > 
> > 
> > I think better to add CONFIG_MMU test here.
> 
> Well, my patch was just something quick to get the kernel to build, but
> thinking about it a bit, I still prefer it. The CONFIG_MMU check is in
> security.h already so I think it is less clutter and better for future
> code which may use mmap_min_addr. In any case, the compiler will drop
> any test for "x < 0UL" so the end result is the same.

Well, sure compiler should optimize it out but frankly i prefer #ifdef here.
Anyway, i'm cooking some new patch. Will post once it's ready and tested.
