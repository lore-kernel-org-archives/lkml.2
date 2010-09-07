Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab0IGUC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 16:02:29 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:58197 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932463Ab0IGUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:02:28 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] usbnet: allow rx_process() to ignore packets
Date: Tue, 7 Sep 2010 22:02:16 +0200
User-Agent: KMail/1.9.10
Cc: David Brownell <dbrownell@users.sourceforge.net>, netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <436709.64173.qm@web180305.mail.gq1.yahoo.com>
In-Reply-To: <436709.64173.qm@web180305.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009072202.18703.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 September 2010 23:35:15 David Brownell wrote:
> > > > From: Ondrej Zary <linux@rainbow-software.org>
> > > > Subject: [PATCH] usbnet: allow rx_process() to
> >
> > ignore packets
> >
> > > It already can ... I'm already not
> > > liking this patch...
>
> You didn't explain why "ignore".  As a rule, if
> the network peer is sending garbage, that needs
> to be accounted as an error, not igored.  You seem
> to be complaining about accounting garbage as such.

It's not a garbage, just a packet that is not yet complete.

>  rx_process() knows only two cases:
> > either rx_fixup()
> > returns 0 or a non-zero value. If I return 0,
> >  the error counter is  incremented.
>
> So don't return zero, when you're not trying to
> indicate an error. ... easy.

If I return 1, the incomplete packet would be passed up the stack.

> > If I return non-zero value, packet is
> > processed ("passed up the
> > stack" - usbnet_skb_return() called)
> > if the skb has non-zero length,
>
> Exactly -- that's how the minidriver says that
> it stripped framing off the packet, so other
> code should pass the packet up the stack.
>
>
> Have you tried emptying the SKB (len zero) to
> indicate you've consumed all of its contents?
> (Or in your case, "ignored").  That would seem to
> be more like what you want to do ...  ISTR that the
> network stack cleanly handles empty SKBs; if not,
> maybe it should.

Yes, I have tried it - in fact, this is that cx82310_eth does now. It does not 
work because rx_process() in usbnet.c checks if the skb is empty - and 
increments the error counter if it is. Maybe it should not?

-- 
Ondrej Zary
