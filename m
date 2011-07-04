Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab1GDPlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:41:35 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39692 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab1GDPlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:41:32 -0400
Date: Mon, 4 Jul 2011 09:41:29 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: pca953x: support working w/o platform data
Message-ID: <20110704154129.GF29977@ponder.secretlab.ca>
References: <BANLkTimSkDEzPvRMmX1O0YjjpoPzQt6_+w@mail.gmail.com>
 <4E0E0138.8060400@compulab.co.il>
 <20110704064347.GL15152@ponder.secretlab.ca>
 <4E116F7F.5010508@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E116F7F.5010508@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 10:45:03AM +0300, Igor Grinberg wrote:
> On 07/04/11 09:43, Grant Likely wrote:
> 
> > On Fri, Jul 01, 2011 at 08:17:44PM +0300, Igor Grinberg wrote:
> >> On 07/01/11 14:33, Christian Gmeiner wrote:
> >>
> >>> Provide defaults for pca953x, so the driver can be used w/o
> >>> providing platform data.
> >> Wouldn't it be better to provide a default pdata structure inside the driver
> >> and use it in case no pdata supplied, so you will not have to patch the
> >> driver all around checking each time if pdata is valid?
> >
> > I would agree.  However, you will need to adjust the structure of the
> > driver somewhat to do so.  Once a device is registered, the data
> > pointed to by platform_device->dev.platform_data must be treated as
> > immutable by the driver, otherwise driver unbind/rebind can become
> > horribly broken.
> 
> The driver already copies several field from pdata to the chip structure.
> Also, chip->dyn_pdata can be used for this purpose, but instead of
> allocating it dynamically, it just can be  a part of the chip structure.
> 
> > I often solve this by keeping a full copy of the pdata structure in
> > the driver's private data structure, and always referencing the 'safe'
> > local copy instead of dereferencing dev->platform_data every time.
> 
> If this is done and the chip structure will contain all the information
> needed (either flat, or in some kind of dyn_pdata), then indeed there
> will be no need to access the pdata anymore.
> Also, there will be no need to allocate pdata in pca953x_get_alt_pdata()
> function.
> I think this would be the most clean and safe way.

Yup!  :-)

g.

