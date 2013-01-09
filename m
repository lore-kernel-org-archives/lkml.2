Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3AIXEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 18:04:16 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:39776 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173Ab3AIXEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 18:04:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, gregkh@linuxfoundation.org,
        mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: USB autosuspend vs. URB submission
Date: Thu, 10 Jan 2013 00:05:55 +0100
Message-ID: <2664900.viczl5BYBS@avalon>
User-Agent: KMail/4.9.2 (Linux/3.6.11-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20130108160321.GC12363@hansolo.jdub.homelinux.org>
References: <20130107204220.GB12363@hansolo.jdub.homelinux.org> <Pine.LNX.4.44L0.1301081047170.1535-100000@iolanthe.rowland.org> <20130108160321.GC12363@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On Tuesday 08 January 2013 11:03:22 Josh Boyer wrote:
> On Tue, Jan 08, 2013 at 10:51:20AM -0500, Alan Stern wrote:
> > On Mon, 7 Jan 2013, Josh Boyer wrote:
> > > Hi,
> > > 
> > > We've had a few reports in Fedora of users hitting the WARN_ONCE in
> > > drivers/usb/core/urb.c that prints a warning about a usb_submit_urb
> > > being called on an active URB.  One of them[1] is from the ums_realtek
> > > driver and the other[2] is from the uvcvideo driver.  However, I noticed
> > > that in both instances it seems the devices were coming back from what I
> > > think is autosuspend.
> > > 
> > > I didn't immediately find any similar reports, and to my rather
> > > inexperienced eyes the drivers didn't seem to be doing anything clearly
> > > wrong.  I'm wondering if anyone has some possible ideas for debugging
> > > and whether or not this might be a general issue?
> > 
> > I don't see anything wrong either.
> > 
> > Can you ask the users to collect a usbmon trace covering the period
> > when the problem occurs?
> 
> I'll certainly ask. I'm not particularly hopeful for great results though,
> as the problems seem to be rather intermittent.
> 
> Thanks for taking a look.

I've never heard of such problems with the uvcvideo driver, and I don't see 
anything wrong with the code at first sight. The driver only submits URBs when 
starting the video capture (at that point no URB should be in flight) or in 
the URB completion handler (by definition the URB has completed then).

I've had a quick look at the trace posted at 
https://bugzilla.redhat.com/show_bug.cgi?id=879462 but usbmon only shows URBs 
that are successfully submitted. I'm not sure what useful information I could 
get from the trace.

-- 
Regards,

Laurent Pinchart

