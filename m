Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab2BAMxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 07:53:09 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:37991 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754335Ab2BAMxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 07:53:07 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David Laight" <David.Laight@aculab.com>
Subject: Re: [PATCH 01/16] eicon: fix -Warray-bounds warning
Date: Wed, 1 Feb 2012 13:52:18 +0100
User-Agent: KMail/1.9.10
Cc: "Karsten Keil" <kkeil@linux-pingi.de>,
        "Ben Hutchings" <bhutchings@solarflare.com>,
        "Armin Schindler" <mac@melware.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "Karsten Keil" <isdn@linux-pingi.de>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E45@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6E45@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202011352.19539.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328100787;17f930aa;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 1. Februar 2012, David Laight wrote:
> > -----Original Message-----
> > From: netdev-owner@vger.kernel.org
> > [mailto:netdev-owner@vger.kernel.org] On Behalf Of Danny Kukawka
> > Sent: 31 January 2012 17:04
> > To: Karsten Keil
> > Cc: Ben Hutchings; Armin Schindler;
> > linux-kernel@vger.kernel.org; netdev@vger.kernel.org; Karsten Keil
> > Subject: Re: [PATCH 01/16] eicon: fix -Warray-bounds warning
> >
> > On Dienstag, 31. Januar 2012, Karsten Keil wrote:
> > > On Mon, Jan 30, 2012 at 11:09:32PM +0000, Ben Hutchings wrote:
> > > > On Mon, 2012-01-30 at 23:00 +0100, Danny Kukawka wrote:
> > > > > Fix for a -Warray-bounds warning. mixer_notify_update() tries to
> > > > > write to ((CAPI_MSG *) msg)->info.facility_req.structs[3] while
> > > > > structs is defined as byte structs[1], define structs[1] as
> > > > > structs[4].
> > > >
> > > > I suspect that all the 'byte structs[1];' fields defined
> >
> > in that header
> >
> > > > are actually variable-length arrays.  In that case, there
> >
> > may be no
> >
> > > > reasonable bound you can specify.
> > >
> > > Yes, exactely, the structs is a ASN1 coded message so it
> >
> > can have any len.
> >
> > So, how can we get rid of the compiler warning then?
>
> Try defining it as a 'variable sized array' - byte structs[0].

Okay, that works. I'll send an updated patch.

Thanks

Danny
> 	David
