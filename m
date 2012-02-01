Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab2BAJFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 04:05:15 -0500
Received: from mx0.aculab.com ([213.249.233.131]:51470 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753980Ab2BAJFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 04:05:08 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 01/16] eicon: fix -Warray-bounds warning
Date: Wed, 1 Feb 2012 09:04:48 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E45@saturn3.aculab.com>
In-Reply-To: <201201311804.20464.danny.kukawka@bisect.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/16] eicon: fix -Warray-bounds warning
Thread-Index: AczgOnoxHay8jt8aR1u7f+Xf/9MGbAAhfbeA
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Danny Kukawka" <danny.kukawka@bisect.de>,
        "Karsten Keil" <kkeil@linux-pingi.de>
Cc: "Ben Hutchings" <bhutchings@solarflare.com>,
        "Armin Schindler" <mac@melware.de>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, "Karsten Keil" <isdn@linux-pingi.de>
X-OriginalArrivalTime: 01 Feb 2012 09:04:48.0732 (UTC) FILETIME=[8CCA69C0:01CCE0C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: netdev-owner@vger.kernel.org 
> [mailto:netdev-owner@vger.kernel.org] On Behalf Of Danny Kukawka
> Sent: 31 January 2012 17:04
> To: Karsten Keil
> Cc: Ben Hutchings; Armin Schindler; 
> linux-kernel@vger.kernel.org; netdev@vger.kernel.org; Karsten Keil
> Subject: Re: [PATCH 01/16] eicon: fix -Warray-bounds warning
> 
> On Dienstag, 31. Januar 2012, Karsten Keil wrote:
> > On Mon, Jan 30, 2012 at 11:09:32PM +0000, Ben Hutchings wrote:
> > > On Mon, 2012-01-30 at 23:00 +0100, Danny Kukawka wrote:
> > > > Fix for a -Warray-bounds warning. mixer_notify_update() tries to
> > > > write to ((CAPI_MSG *) msg)->info.facility_req.structs[3] while
> > > > structs is defined as byte structs[1], define structs[1] as
> > > > structs[4].
> > >
> > > I suspect that all the 'byte structs[1];' fields defined 
> in that header
> > > are actually variable-length arrays.  In that case, there 
> may be no
> > > reasonable bound you can specify.
> >
> > Yes, exactely, the structs is a ASN1 coded message so it 
> can have any len.
> 
> So, how can we get rid of the compiler warning then?

Try defining it as a 'variable sized array' - byte structs[0].

	David


