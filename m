Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab1KEVjp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 17:39:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab1KEVjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 17:39:44 -0400
Subject: Re: [PULL] Add support for Texas Instruments C6X architecture
From: Mark Salter <msalter@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 05 Nov 2011 17:39:41 -0400
In-Reply-To: <CA+55aFxXVwX6Y8Nw+V6k0niZ==fxAGfE=-FDYz8nCV4Pw9HEyw@mail.gmail.com>
References: <1320179267.14825.107.camel@deneb.redhat.com>
	 <CA+55aFxXVwX6Y8Nw+V6k0niZ==fxAGfE=-FDYz8nCV4Pw9HEyw@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1320529182.14081.78.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-04 at 18:23 -0700, Linus Torvalds wrote:
> On Tue, Nov 1, 2011 at 1:27 PM, Mark Salter <msalter@redhat.com> wrote:
> >
> > Please pull this port of Linux to the Texas Instruments C6X architecture.
> > The patches have all been acked and available for some time in linux-net.
> 
> Ugh. So I finally was about to merge this, but wanted to check the
> non-C6x files before I did.
> 
> And that seems broken. If I read that code correctly, your
> ARCH_PFN_OFFSET thing is just insane, and thinking that "pfn_valid()"
> has anything to do with PAGE_OFFSET is crazy.
> 
> PAGE_OFFSET is about *virtual* addresses. It has absolutely nothing to
> do with pfn's that are the physical page number. virt_to_pfn() already
> corrects for PAGE_OFFSET (that part of your patch looks fine), your
> change to *also* do it in pfn_valid() looks entirely bogus to me.
> 
> I'm not pulling new architectures that look like they will break old
> ones, and do odd things to generic files.

Okay, first of all, it doesn't break any old ones. There is one arch
that currently uses asm-generic/page.h (blackfin) and that one uses a
PAGE_OFFSET of 0x0 and has physical RAM starting at 0x0. My patch (wrong
as it may otherwise be) won't break blackfin.

Are you saying that PAGE_OFFSET should always be zero in the NOMMU case?
Or that ARCH_PFN_OFFSET shouldn't use PAGE_OFFSET (five existing arches
use that same definition)?

If PAGE_OFFSET should be zero for NOMMU, then the existing generic
page.h is wrong to use CONFIG_KERNEL_RAM_BASE_ADDRESS. Also,
free_area_init() in mm/page_alloc.c uses __pa(PAGE_OFFSET) which
seems wrong and is definitely broken in the NOMMU case if PAGE_OFFSET
must be zero on an arch where the RAM base is non-zero.

So what do I need to do to get this straightened out?

--Mark




