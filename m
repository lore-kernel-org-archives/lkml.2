Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab0IKUWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 16:22:22 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:40603 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751785Ab0IKUWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 16:22:16 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] usbnet: do not count empty skbs as errors in rx_process()
Date: Sat, 11 Sep 2010 22:22:03 +0200
User-Agent: KMail/1.9.10
Cc: netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <704982.67431.qm@web180312.mail.gq1.yahoo.com>
In-Reply-To: <704982.67431.qm@web180312.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009112222.06149.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 September 2010 21:07:59 David Brownell wrote:
> --- On Fri, 9/10/10, Ondrej Zary <linux@rainbow-software.org> wrote:
> > From: Ondrej Zary <linux@rainbow-software.org>
> > Subject: [PATCH v2] usbnet: do not count empty skbs as errors in
> > rx_process()
>
> NAK to this backwards-incompatible change.
>
> At this point there's no way to know how many
> drivers it breaks ... I do know that counting
> such SKBs as errors has previously turned up
> link-level errors, and thus led to bugfixes.
>
> > If rx_fixup() returns an empty skb
> > (because it consumed all data inside),
>
> The canonical reason the SKB would be empty is
> because after rx_fixup() removed all header and
> trailer data, there was no packet body left.
> Which is likely a link error, and has been
> worth accounting as such in the past (turned up
> bugs on TX or RX sides).
>
> > do not count it as error.
> >
> > This is needed for cx82310_eth.
>
> I'd far rather see that driver fixed, than see
> the core usbnet framework broken to avoid such
> fixes to a very new driver ...

I already tried to explain that the driver is not broken and so it cannot be 
fixed. It's the way the hardware works and usbnet is not ready for it. I see 
no way to process a packet that crosses URBs (and thus SKBs) without changing 
usbnet.

-- 
Ondrej Zary
