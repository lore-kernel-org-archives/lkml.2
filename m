Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab0GJPnd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 11:43:33 -0400
Received: from 8bytes.org ([88.198.83.132]:43008 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717Ab0GJPnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 11:43:32 -0400
Date: Sat, 10 Jul 2010 17:43:31 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.35-rc3] select useful number of entries for DMA
	debugging...
Message-ID: <20100710154331.GF10080@8bytes.org>
References: <AANLkTilPtW_hOG01qvQHBWMC4b0QJZ8SAL0bZi6j56ns@mail.gmail.com> <AANLkTilQ0w6EfbrXl5LklPJ46FMWQG6Q3W5twJY74RtE@mail.gmail.com> <AANLkTinLjhLoQJ8URiuCKqgntiLEKxCesNEPZ8b24uLu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinLjhLoQJ8URiuCKqgntiLEKxCesNEPZ8b24uLu@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 03:52:04PM +0100, Daniel J Blueman wrote:
> On 9 July 2010 22:33, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Mon, Jul 5, 2010 at 1:35 AM, Daniel J Blueman
> > <daniel.blueman@gmail.com> wrote:
> >> When booting 2.6.35-rc3 on some different x86 boxes with DMA debugging
> >> enabled, I've consistently seen it exhaust the allocated entries during
> >> boot, giving 'DMA-API: debugging out of memory - disabling'.
> >>
> >> Increase number of entries to allow DMA debugging again.
> >
> > Rather than increase the default that gets allocated whenever anybody
> > enables the DMA debugging, I'd really prefer to see people use the
> > kernel command line option if they run out. After all, it's a (pretty
> > esoteric) debug option, and the number of required entries depends on
> > machine configuration. I'd rather not make the default cover a huge
> > number, when you could just add
> >
> >   dma_debug_entries=65536
> >
> > on the kernel boot command line instead for machines that want/need it..
> 
> That said, I am seeing the DMA pool exhaust on a single socket Core i5
> system with Intel graphics and no other adapters - seems like a fairly
> common case. If eg 25% of developers will be using similar to this,
> maybe it's good to make DMA debugging less immediately esoteric?
> 
> On the other hand, I would immediately agree if the exhaustion
> occurred on an atypical setup.

How much memory do you have in this machine? We could probably make the
number of pre-allocated entries dependent on the memory available in the
machine like Ingo suggested some time ago to avoid such problems.

	Joerg

