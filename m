Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475Ab1FWOM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:12:28 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:48003 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758132Ab1FWOM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:12:27 -0400
Date: Thu, 23 Jun 2011 18:11:37 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: matt mooney <mfm@muteddisk.com>
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC, PATCH] USB: EHCI: Allow users to override 80% max
	periodic bandwidth
Message-ID: <20110623141137.GB4403@tugrik.mns.mnsspb.ru>
References: <1308758567-8205-1-git-send-email-kirr@mns.spb.ru> <20110622173045.GC56479@haskell.muteddisk.com> <20110622173544.GD56479@haskell.muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622173544.GD56479@haskell.muteddisk.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 10:35:44AM -0700, matt mooney wrote:
> On 10:30 Wed 22 Jun     , matt mooney wrote:
> > On 20:02 Wed 22 Jun     , Kirill Smelkov wrote:
> > > There are cases, when 80% max isochronous bandwidth is too limiting.
> > > 
> > > For example I have two USB video capture cards which stream uncompressed
> > > video, and to stream full NTSC + PAL videos we'd need
> > > 
> > >     NTSC 640x480 YUV422 @30fps      ~17.6 MB/s
> > >     PAL  720x576 YUV422 @25fps      ~19.7 MB/s
> > > 
> > > isoc bandwidth.
> > > 
> > > Now, due to limited alt settings in capture devices NTSC one ends up
> > > streaming with max_pkt_size=2688  and  PAL with max_pkt_size=2892, both
> > > with interval=1. In terms of microframe time allocation this gives
> > > 
> > >     NTSC    ~53us
> > >     PAL     ~57us
> > > 
> > > and together
> > > 
> > >     ~110us  >  100us == 80% of 125us uframe time.
> > > 
> > > So those two devices can't work together simultaneously because the'd
> > > over allocate isochronous bandwidth.
> > > 
> > > 80% seemed a bit arbitrary to me, and I've tried to raise it to 90% and
> > > both devices started to work together, so I though sometimes it would be
> > > a good idea for users to override hardcoded default of max 80% isoc
> > > bandwidth.
> > 
> > There is nothing arbitrary about 80%. The USB 2.0 Specification constrains
> > periodic transfers for high-speed endpoints to 80% of the microframe. See
> > section 5.6.4.
> > 
> 
> Looking at the patch, I see that you probably already knew that.
> 
> So I digress and defer to the USB experts ;)

Yes, it was meant as 80% being arbitrary chosen by USB 2.0
specification. Notes taken - I'll clarify patch description.


Thanks for commenting,
Kirill
