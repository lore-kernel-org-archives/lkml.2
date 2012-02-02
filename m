Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab2BBSZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 13:25:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63889 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab2BBSZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 13:25:26 -0500
Date: Thu, 2 Feb 2012 19:25:15 +0100
From: Karsten Keil <kkeil@linux-pingi.de>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: David Laight <David.Laight@aculab.com>,
        Karsten Keil <kkeil@linux-pingi.de>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Armin Schindler <mac@melware.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>
Subject: Re: [PATCH 01/16] eicon: fix -Warray-bounds warning
Message-ID: <20120202182515.GA11660@gw.linux-pingi.de>
Mail-Followup-To: Danny Kukawka <danny.kukawka@bisect.de>,
	David Laight <David.Laight@aculab.com>,
	Karsten Keil <kkeil@linux-pingi.de>,
	Ben Hutchings <bhutchings@solarflare.com>,
	Armin Schindler <mac@melware.de>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E45@saturn3.aculab.com>
 <201202011352.19539.danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202011352.19539.danny.kukawka@bisect.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:mUIk++qsDuDuAM256GWudT+O7vcwymzsWTDIjCRcC4b
 bpFre5FA3RHCaGhdPhgGw+Fca1O+l+cCxYxC7nGIx6F8+9wFiy
 kDiaCxbuLWGhX/viCEpy+Dz52pqyWaY7w6CThlSxzoI/jTAWJ3
 57m9iOLg1IXqtfl87/CLupBHXq6cIwag800X6+2ON3gx3bIw5e
 gwAfp+Lm8MdUg5q5IKivAMVBTAQ94J8MUHQ4RYTRP6CzqmNCxo
 DXULfJKRDO1oaDKaAQmZV9PKSJhwPVRX5zqUQ/DtQ8E7Fdul6q
 nivCeA1I8aBfnWKbFdxUy4acYXiCF2wSxFPKFBkRMkJKan+J1o
 0QncR5XgmDFmZjbvbrOiOTi+2MIEE4O5T5PJLXhGLlFCh4fgwA
 AfgyEoeeIYOkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 01:52:18PM +0100, Danny Kukawka wrote:
> On Mittwoch, 1. Februar 2012, David Laight wrote:
> > > -----Original Message-----
> > > From: netdev-owner@vger.kernel.org
> > > [mailto:netdev-owner@vger.kernel.org] On Behalf Of Danny Kukawka
> > > Sent: 31 January 2012 17:04
> > > To: Karsten Keil
> > > Cc: Ben Hutchings; Armin Schindler;
> > > linux-kernel@vger.kernel.org; netdev@vger.kernel.org; Karsten Keil
> > > Subject: Re: [PATCH 01/16] eicon: fix -Warray-bounds warning
> > >
> > > On Dienstag, 31. Januar 2012, Karsten Keil wrote:
> > > > On Mon, Jan 30, 2012 at 11:09:32PM +0000, Ben Hutchings wrote:
> > > > > On Mon, 2012-01-30 at 23:00 +0100, Danny Kukawka wrote:
> > > > > > Fix for a -Warray-bounds warning. mixer_notify_update() tries to
> > > > > > write to ((CAPI_MSG *) msg)->info.facility_req.structs[3] while
> > > > > > structs is defined as byte structs[1], define structs[1] as
> > > > > > structs[4].
> > > > >
> > > > > I suspect that all the 'byte structs[1];' fields defined
> > >
> > > in that header
> > >
> > > > > are actually variable-length arrays.  In that case, there
> > >
> > > may be no
> > >
> > > > > reasonable bound you can specify.
> > > >
> > > > Yes, exactely, the structs is a ASN1 coded message so it
> > >
> > > can have any len.
> > >
> > > So, how can we get rid of the compiler warning then?
> >
> > Try defining it as a 'variable sized array' - byte structs[0].
> 
> Okay, that works. I'll send an updated patch.
> 

Nice, I did not know this way.

Karsten
