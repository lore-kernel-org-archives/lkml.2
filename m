Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab0EGJrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:47:46 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59209 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755023Ab0EGJrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:47:45 -0400
X-Sasl-enc: dJ8U/T5wiwi+oHZ6+raLCAAICFIZtds9dvUbp4TQiB9+ 1273225660
Message-ID: <4BE3E1B9.5020602@ladisch.de>
Date: Fri, 07 May 2010 11:47:37 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
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
References: <g2h74fd948d1004141820ladc1941eo732d059dd678df0a@mail.gmail.com>	<Pine.LNX.4.44L0.1004151114490.1562-100000@iolanthe.rowland.org>	<t2r74fd948d1004191716l49dedc2p25a27da39bcc614a@mail.gmail.com> <20100507074855.GF30801@buzzloop.caiaq.de>
In-Reply-To: <20100507074855.GF30801@buzzloop.caiaq.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> The problem is again (summarized):
> 
> On 64bit machines, with 4GB or more, the allocated buffers for USB
> transfers might be beyond the 32bit boundary. In this case, the IOMMU
> should take care and install DMA bounce buffer to copy over the buffer
> before the transfer actually happens. The problem is, however, that this
> copy mechanism takes place when the URB with its associated buffer is
> submitted, not when the EHCI will actually do the transfer.
> 
> In the particular case of audio drivers, though, the contents of the
> buffers are likely to change after the submission. What we do here
> is that we map the audio stream buffers which are used by ALSA to
> the output URBs, so they're filled asychronously. Once the buffer is
> actually sent out on the bus, it is believed to contain proper audio
> date. If it doesn't, that's due to too tight audio timing or other
> problems. This breaks once buffers are magically bounced in the
> background.

At least the audio class and ua101 drivers don't do this and fill the
buffers before they are submitted.

> So - long story short: these audio buffers need to be DMA coherent.

Does the USB API actually guarantee that all controllers use DMA, i.e.,
that the buffers can be filled after submission?


Regards,
Clemens
