Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab2GaIa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 04:30:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35788 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab2GaIa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 04:30:29 -0400
Date: Tue, 31 Jul 2012 10:30:22 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: About dma_sync_single_for_{cpu,device}
Message-ID: <20120731083022.GA5026@ed-laptop>
References: <20120730202401.GA4947@gobelin>
 <20120731064557.GA4676@gobelin>
 <50178249.7090306@ladisch.de>
 <CACYmx9O_TJoSmhiai_Mv09JE3HZ+-V=w8KobTn3zPXtkWbojkw@mail.gmail.com>
 <50178A69.8050906@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50178A69.8050906@ladisch.de>
X-Location: France
User-Agent: Mutt (Linux 3.5.0-rc4+ i686 GNU/Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 09:34:01AM +0200, Clemens Ladisch wrote:
> Karl Beldan wrote:
> > On 7/31/12, Clemens Ladisch <clemens@ladisch.de> wrote:
> >> Karl Beldan wrote:
> >>> To tx a chunk of data from the SoC => network device, we :
> >>> - prepare a buffer with a leading header embedding a pattern,
> >>> - trigger the xfer and wait for an irq
> >>> // The device updates the pattern and then triggers an irq
> >>> - upon irq we check the pattern for the xfer completion
> >>>
> >>> I was expecting the following to work:
> >>> 	addr = dma_map_single(dev, buffer, size, DMA_TO_DEVICE);
> >>
> >> Of both the CPU and the device write to the buffer, you must use
> >> DMA_BIDIRECTIONAL.
> >
> > This does not work (tested) :  seems to me BIDIRECTIONAL would just
> > add invalidate, and invalidate before the ram has been updated, as
> > stated, does not work.
> 
> Please show the exact sequence of dma_* calls, and also show when and
> how the CPU and the device access the buffer.
> 
Hmm, so I just spotted a line where we peek in the buffer after
invalidating .. cannot believe I missed it .. so sorry for the noise ..
now it's working.
I felt I would find the culprit right after posting ;)
Thanks Clemens !
