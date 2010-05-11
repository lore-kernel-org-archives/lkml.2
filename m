Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab0EKRKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:10:46 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:43324 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab0EKRKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:10:45 -0400
Date: Tue, 11 May 2010 19:10:25 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, gregkh@suse.de,
       konrad.wilk@oracle.com, tiwai@suse.de,
       USB list <linux-usb@vger.kernel.org>, clemens@ladisch.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       andi@firstfloor.org, Andrew Morton <akpm@linux-foundation.org>,
       dwmw2@infradead.org
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
Message-ID: <20100511171025.GB30801@buzzloop.caiaq.de>
References: <20100512003450P.fujita.tomonori@lab.ntt.co.jp>
 <Pine.LNX.4.44L0.1005111158420.1834-100000@iolanthe.rowland.org>
 <AANLkTikoF4qgkN9p0SpDEOrHAMxdh4jzPusCdrq1tRag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikoF4qgkN9p0SpDEOrHAMxdh4jzPusCdrq1tRag@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 05:48:11PM +0100, Pedro Ribeiro wrote:
> I'm clueless about the whole underlying process but I don't think it
> is related to playing a file from the disk or another USB device.
> 
> I don't need to play any file for this interference to be heard - I
> just need to "open" the device. By this I mean that if I create a JACK

... which will stream zeros. Sure, that should also trigger the bug
then.

> server or if I open the device using the ALSA backed in a program like
> Mixxx I immediately start hearing the cracks and pops in the speaker.
> But to answer your question, playing a file from the hard drive using
> aplay I can also hear the interference - but only when the sound is
> playing. As soon as the sound stops and the audio device is "closed",
> no interference occurs.

Yes, because the stream is stopped, pending URBs are unlinked etc.
That's completely expected.

> However, when using the JACK server, which probably opens and polls
> the audio card constantly (its a low latency audio server) I don't
> even need to be playing any sound for the interference to be constant.

That shouldn't affect the driver itself but just put the ALSA core under
pressure.

> I can also see it since I have 4 output leds in the USB audio card and
> even if I'm only using 2 channels, the 4 channel leds light up with
> interference as the sound cracks and pops.

No surprise here. The 4 channels are mux'ed in an interleaved fashion,
so if the buffers contain rubbish, you will hear artefacts on all
channels.

Daniel

