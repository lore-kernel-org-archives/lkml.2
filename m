Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab0DLMcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 08:32:46 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:53018 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0DLMco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 08:32:44 -0400
Date: Mon, 12 Apr 2010 14:32:38 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pedro Ribeiro <pedrib@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100412123238.GW30801@buzzloop.caiaq.de>
References: <20100407090623.GN30807@buzzloop.caiaq.de>
 <Pine.LNX.4.44L0.1004071036060.1779-100000@iolanthe.rowland.org>
 <87sk719hbm.fsf@basil.nowhere.org>
 <20100412111439.GU30801@buzzloop.caiaq.de>
 <20100412115300.GM18855@one.firstfloor.org>
 <q2z74fd948d1004120511hebf19eaauc41ee9ed25dea19e@mail.gmail.com>
 <20100412121243.GN18855@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412121243.GN18855@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 02:12:43PM +0200, Andi Kleen wrote:
> > I'm not putting into question whether something is broken in my
> > system, but if it is, it must be the ICH9 platform, because I was able
> > to reproduce it in another laptop.
> > 
> > My laptop is a Lenovo T400 and I was able to reproduce it in a Acer
> > Aspire 59xx (I don't remember the exact model, but it is one of the
> > new ones with 15.6 inch - i think they all use the same base). And the
> > common thing between them is the ICH9 platform.
> 
> There are lots of systems around with ICH9 that work fine.
> I'm typing on one.

FWIW, the fix that made it work for Pedro was to use usb_buffer_alloc()
for the transfer_buffer of the audio module.

Another detail I can't explain is that on his machine, the kernel oopses
when kmalloc() with GFP_DMA32 is used. The patch to try this also only
touched the allocation in sound/usb/caiaq/audio.c.

> > The only which solved this problem was the first patch sent to me by
> > Daniel Mack. I've been using it for days straight and it works fine.
> 
> Can you send a full boot log?

He just did. I put it online here:

  http://caiaq.de/download/tmp/pedro-dmesg

Daniel
