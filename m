Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab0EZHdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:33:47 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:48664 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab0EZHdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:33:45 -0400
Date: Wed, 26 May 2010 16:33:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Jie Zhang <jie@codesourcery.com>, uclinux-dev@uclinux.org,
       David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
       linux-m32r@ml.linux-m32r.org, Hirokazu Takata <takata@linux-m32r.org>,
       linux-kernel@vger.kernel.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [PATCH] FLAT: allow arches to declare a larger alignment than the slab
Message-ID: <20100526073334.GD26696@linux-sh.org>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org> <20100525210755.GA8920@linux-sh.org> <AANLkTinTbJ3yu9ElO32rnavnGwCrsItdDCl58KoeEW3j@mail.gmail.com> <4BFC8617.9010501@codesourcery.com> <AANLkTilU133SjYfKGvUiQQ8v-CiecRYmKtH2tzAxL-3u@mail.gmail.com> <AANLkTimWuqtLtnrgA8SHa-XoN8YdHJhQ6F2BngmmKSrl@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimWuqtLtnrgA8SHa-XoN8YdHJhQ6F2BngmmKSrl@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 03:23:02AM -0400, Mike Frysinger wrote:
> On Wed, May 26, 2010 at 02:59, Geert Uytterhoeven wrote:
> > From looking at <linux/flat.h>, it looks like the FLAT binary format
> > doesn't contain any
> > alignment information? So if I put __attribute__((aligned(4096))) in a
> > file, there's still
> > no guarantee it will actually be in memory at a 4Ki-aligned address?
> 
> i believe that is correct.  FLAT behavior today provides alignment of
> either sizeof(unsigned long) or ARCH_SLAB_MINALIGN.
> 
> i imagine something like this would work today because everyone
> defines it to a constant:
> -#ifdef ARCH_SLAB_MINALIGN
> +#if defined(ARCH_SLAB_MINALIGN) && ARCH_SLAB_MINALIGN != 0
> but this would break if someone tried using gcc sizeof/alignof/etc...

alignof is used by SLUB/SLOB to set the ARCH_SLAB_MINALIGN value if the
architecture hasn't already specified one, so that wouldn't work.
