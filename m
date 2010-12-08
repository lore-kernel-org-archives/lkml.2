Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0LHAMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:12:46 -0500
Received: from kroah.org ([198.145.64.141]:58080 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013Ab0LHAMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:12:44 -0500
Date: Tue, 7 Dec 2010 16:12:02 -0800
From: Greg KH <greg@kroah.com>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
        Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Message-ID: <20101208001202.GA26530@kroah.com>
References: <732182.60247.qm@web31816.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <732182.60247.qm@web31816.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 04:02:26PM -0800, Luben Tuikov wrote:
> --- On Sun, 12/5/10, Luben Tuikov <ltuikov@yahoo.com> wrote:
> > --- On Wed, 11/24/10, Luben Tuikov
> > <ltuikov@yahoo.com>
> > wrote:
> > > 
> > > CBI/BBB isn't supposed to be, nor is designed to
> > support
> > > SAM-modern devices. So while REQUEST LUN /may/ work on
> > some
> > > devices which implement it in their firmware, it is
> > NOT a
> > > requirement for those devices as they are not required
> > to
> > > adhere to any SAM version. Those transport protocols
> > define
> > > a class-specific request to get the maximum LUN, and
> > another
> > > to reset the target port (instead of I_T Reset or LU
> > Reset).
> > > They also do not support SCSI Status completion of
> > the
> > > command, nor Autosense. They also do not provide TMFs.
> > They
> > > provide none of the SCSI transport protocol services
> > in
> > > support of the Execute Command procedure call. The
> > SCSI
> > > layer shouldn't be trying to guess their "SCSI
> > version", and
> > > or treat them as real SCSI devices sending REPORT
> > LUNs, etc.
> > > commands.
> > > 
> > > Newer, modern transport protocols over USB, are part
> > of
> > > SAM, and it is devices who connect via those protocols
> > that
> > > are being disadvantaged, due to the adoption
> > (assumption) of
> > > CBI/BBB well into the SCSI layer.
> > > 
> > > To this effect, the transport protocol can tell upper
> > > layers if the device is true SCSI (new usb transports
> > or
> > > other) or hybrid (usb-storage). In the former case,
> > the
> > > device is a SCSI device, in the latter, only basic
> > commands
> > > should be attempted.
> > > 
> > > This isn't to say that firmware for those devices
> > wouldn't
> > > be buggy. Of course it will, and most will probably
> > port
> > > their legacy FW over to the new SPTL, but the
> > protocol
> > > requirements are there by design (i.e. there is no
> > longer
> > > Get Max Lun class-specific request, the application
> > client
> > > has to send REPORT LUNS, and FW has to answer it) and
> > we
> > > have to accommodate that.
> > > 
> > > It is in this spirit that this patch doesn't change
> > wire
> > > behavior, but simply parses data returned by a
> > command
> > > already supported by older protocols.
> > 
> > Did anyone pick up this patch?
> 
> It's been over 6 weeks now that this patch's been in these mailing lists.
> Will anyone pick up this patch, or should I stop posting it every
> week? Please let me know--it's been posted here 6 times in the last 6
> weeks.

James, this is all you.  Any thoughts?

thanks,

greg k-h
