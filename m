Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab0EGKYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 06:24:15 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:58761 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab0EGKYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 06:24:13 -0400
Date: Fri, 7 May 2010 12:24:08 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       Greg KH <gregkh@suse.de>,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, iommu@lists.linux-foundation.org,
       Andi Kleen <andi@firstfloor.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Pedro Ribeiro <pedrib@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
Message-ID: <20100507102408.GM30801@buzzloop.caiaq.de>
References: <g2h74fd948d1004141820ladc1941eo732d059dd678df0a@mail.gmail.com>
 <Pine.LNX.4.44L0.1004151114490.1562-100000@iolanthe.rowland.org>
 <t2r74fd948d1004191716l49dedc2p25a27da39bcc614a@mail.gmail.com>
 <20100507074855.GF30801@buzzloop.caiaq.de>
 <4BE3E1B9.5020602@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE3E1B9.5020602@ladisch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 11:47:37AM +0200, Clemens Ladisch wrote:
> Daniel Mack wrote:
> > The problem is again (summarized):
> > 
> > On 64bit machines, with 4GB or more, the allocated buffers for USB
> > transfers might be beyond the 32bit boundary. In this case, the IOMMU
> > should take care and install DMA bounce buffer to copy over the buffer
> > before the transfer actually happens. The problem is, however, that this
> > copy mechanism takes place when the URB with its associated buffer is
> > submitted, not when the EHCI will actually do the transfer.
> > 
> > In the particular case of audio drivers, though, the contents of the
> > buffers are likely to change after the submission. What we do here
> > is that we map the audio stream buffers which are used by ALSA to
> > the output URBs, so they're filled asychronously. Once the buffer is
> > actually sent out on the bus, it is believed to contain proper audio
> > date. If it doesn't, that's due to too tight audio timing or other
> > problems. This breaks once buffers are magically bounced in the
> > background.
> 
> At least the audio class and ua101 drivers don't do this and fill the
> buffers before they are submitted.

Gnaa, you're right. I _thought_ my code does it the way I described, but
what I wrote is how I _wanted_ to do it, not how it's currently done. I
have a plan to change this in the future.

So unfortunately, that doesn't explain it either. Sorry for the noise.

Daniel
