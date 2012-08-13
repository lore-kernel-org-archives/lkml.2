Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab2HMWDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:03:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54706 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab2HMWDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:03:43 -0400
Date: Mon, 13 Aug 2012 17:03:30 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Subject: Re: [PATCH 2/2] apple_gmux: Add support for newer hardware
Message-ID: <20120813220330.GK24088@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	Bernhard Froemel <froemel@vmars.tuwien.ac.at>
References: <1344889232-3907-1-git-send-email-mjg@redhat.com>
 <1344889232-3907-2-git-send-email-mjg@redhat.com>
 <20120813210444.GJ24088@thinkpad-t410>
 <20120813213607.GB27838@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120813213607.GB27838@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 10:36:07PM +0100, Matthew Garrett wrote:
> On Mon, Aug 13, 2012 at 04:04:44PM -0500, Seth Forshee wrote:
> > > +
> > > +	while (i && (gwr & 0x01)) {
> > > +		inb(gmux_data->iostart + GMUX_PORT_READ);
> > > +		gwr = inb(gmux_data->iostart + GMUX_PORT_WRITE);
> > > +		msleep(100);
> > 
> > Wouldn't it make more sense if the msleep was before reading the port
> > again? Otherwise there's no substantial dely between the first and
> > second times we read it.
> 
> Mm. I'm doing the same as the ACPI implementation - it may be that 
> reading GMUX_PORT_READ triggers the update of GMUX_PORT_WRITE? Hard to 
> know without the docs.

Indeed. I do find the structure of the loop to be odd, but I suppose the
safest approach is to follow the only known working implementation we
have. In that case ...

Acked-by: Seth Forshee <seth.forshee@canonical.com>

