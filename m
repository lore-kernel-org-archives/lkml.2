Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266Ab0EYVIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 17:08:10 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42863 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758733Ab0EYVII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 17:08:08 -0400
Date: Wed, 26 May 2010 06:07:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
       linux-m32r@ml.linux-m32r.org, Hirokazu Takata <takata@linux-m32r.org>,
       linux-kernel@vger.kernel.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Jie Zhang <jie.zhang@analog.com>
Subject: Re: [PATCH] FLAT: allow arches to declare a larger alignment than the slab
Message-ID: <20100525210755.GA8920@linux-sh.org>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274815467-14584-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 03:24:27PM -0400, Mike Frysinger wrote:
> This stems from the alignment usage in the FLAT loader.  The behavior
> before was that FLAT would default to ARCH_SLAB_MINALIGN only if it was
> defined, and this was only defined by arches when they wanted a larger
> alignment value.  Otherwise it'd default to pointer alignment.  Arguably,
> this is kind of hokey that the FLAT is semi-abusing defines it shouldn't.
> 
This needs some explaining. What exactly do you find problematic with
ARCH_SLAB_MINALIGN in this case? For the case that was introduced leading
up to the wrapping of the minalign value it was absolutely the proper
thing to use. If blackfin has special alignment requirements on top of
that, then that's certainly fine, but it doesn't negate the validity of
the minalign wrapping for the other platforms.

>  /*
> - * User data (stack, data section and bss) needs to be aligned
> - * for the same reasons as SLAB memory is, and to the same amount.
> + * User data (stack, data section and bss) needs to be aligned.
> + * If ARCH_FLAT_DATA_ALIGN is defined, use it.
> + */

If you're going to update the comment, the update should at least serve
some purpose. This not only obscures the reason for the slab minalign
wrapping, it also fails to suggest why anyone would deviate from that.

If the intention is that ARCH_FLAT_DATA_ALIGN provides cacheline
alignment on blackfin, then use ARCH_KMALLOC_MINALIGN like everyone else.
