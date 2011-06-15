Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1FOPrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:47:15 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:52847 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755534Ab1FOPrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:47:11 -0400
X-Sasl-enc: 4MSJhvXK70cOWpRfsnw2Bn3pt3K2dVtPJQAkqu84RZQH 1308152831
Date: Wed, 15 Jun 2011 08:47:06 -0700
From: Greg KH <greg@kroah.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, brudley@broadcom.com,
        henryp@broadcom.com, rvossen@broadcom.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        sparclinux@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 related)
Message-ID: <20110615154706.GA19707@kroah.com>
References: <20110609172745.dfd3a298.sfr@canb.auug.org.au>
 <20110609184127.GA2760@kroah.com>
 <20110609192243.GA3980@kroah.com>
 <20110610160548.529797c7.sfr@canb.auug.org.au>
 <BANLkTim5dYNmTMJo-Wa3LYCTi4vxPGMNeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim5dYNmTMJo-Wa3LYCTi4vxPGMNeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 02:05:29PM +0200, Geert Uytterhoeven wrote:
> On Fri, Jun 10, 2011 at 08:05, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > On Thu, 9 Jun 2011 12:22:43 -0700 Greg KH <greg@kroah.com> wrote:
> >> On Thu, Jun 09, 2011 at 11:41:27AM -0700, Greg KH wrote:
> >> > > Also in several other files in drivers/staging/brcm80211/
> >> > >
> >> > > Also:
> >> > >
> >> > > drivers/staging/comedi/drivers.c: In function 'comedi_buf_alloc':
> >> > > drivers/staging/comedi/drivers.c:505:37: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)
> 
> I have my doubts
> 
> #ifdef PAGE_KERNEL_NOCACHE
>                             vmap(pages, n_pages, VM_MAP, PAGE_KERNEL_NOCACHE);
> #else
>                             vmap(pages, n_pages, VM_MAP, PAGE_KERNEL);
> #endif
> 
> is the right "fix" for this...
> 
> BTW, PAGE_KERNEL_NOCACHE is defined on frv, m32r, mn10300, sh, and x86 only.
> 
> Strangely, both sparc and tile have
> 
> /*
>  * Some hardware wants to get fixmapped without caching.
>  */
> #define set_fixmap_nocache(idx, phys) \
>                 __set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
> 
> in their <asm/fixmap.h>, without having PAGE_KERNEL_NOCACHE...

So, what should the correct fix here be?

confused,

greg k-h
