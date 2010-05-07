Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab0EGLmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 07:42:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:43262 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab0EGLmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 07:42:53 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
Date: Fri, 7 May 2010 13:42:34 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Daniel Mack <daniel@caiaq.de>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org, Greg KH <gregkh@suse.de>,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, iommu@lists.linux-foundation.org,
       Andi Kleen <andi@firstfloor.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Pedro Ribeiro <pedrib@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
References: <g2h74fd948d1004141820ladc1941eo732d059dd678df0a@mail.gmail.com> <20100507074855.GF30801@buzzloop.caiaq.de> <4BE3E1B9.5020602@ladisch.de>
In-Reply-To: <4BE3E1B9.5020602@ladisch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005071342.34923.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 7. Mai 2010 11:47:37 schrieb Clemens Ladisch:
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
> 
> > So - long story short: these audio buffers need to be DMA coherent.
> 
> Does the USB API actually guarantee that all controllers use DMA, i.e.,
> that the buffers can be filled after submission?

No, you must not touch buffers after submission. This does not even
work if we use DMA, because on some architectures this violates
guarantees to the dma primitives. It cannot be done.

	Regards
		Oliver
