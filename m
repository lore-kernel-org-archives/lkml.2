Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab1LGVPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:15:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50451 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab1LGVPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:15:51 -0500
Date: Wed, 7 Dec 2011 15:15:45 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Rezwanul_Kabir@Dell.com
Cc: mjg59@srcf.ucam.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dell-wmi: Change debug statements from pr_info to
 pr_debug
Message-ID: <20111207211545.GH15875@thinkpad-t410>
Mail-Followup-To: Rezwanul_Kabir@Dell.com, mjg59@srcf.ucam.org,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1321908536-5163-1-git-send-email-seth.forshee@canonical.com>
 <20111121205230.GA14467@srcf.ucam.org>
 <20111121211438.GH6736@thinkpad-t410>
 <20111121211809.GA14950@srcf.ucam.org>
 <20111121222945.GA14306@thinkpad-t410>
 <20111121223209.GA16955@srcf.ucam.org>
 <20111207164315.GE15875@thinkpad-t410>
 <8E5FE4ED189EB4469AF9D819A96C8D4A01EA4AC95F@AUSX7MCPC108.AMER.DELL.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8E5FE4ED189EB4469AF9D819A96C8D4A01EA4AC95F@AUSX7MCPC108.AMER.DELL.COM>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 02:22:31PM -0600, Rezwanul_Kabir@Dell.com wrote:
> 
> > -----Original Message-----
> > From: platform-driver-x86-owner@vger.kernel.org [mailto:platform-driver-
> > x86-owner@vger.kernel.org] On Behalf Of Seth Forshee
> > Sent: Wednesday, December 07, 2011 10:43 AM
> > To: Matthew Garrett
> > Cc: platform-driver-x86@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] dell-wmi: Change debug statements from pr_info to
> > pr_debug
> > 
> > On Mon, Nov 21, 2011 at 10:32:09PM +0000, Matthew Garrett wrote:
> > > > > On Mon, Nov 21, 2011 at 03:14:38PM -0600, Seth Forshee wrote:
> > > > > > On Mon, Nov 21, 2011 at 08:52:30PM +0000, Matthew Garrett wrote:
> > > > > > > They're intended to be there, in the same way that the
> > > > > > > keyboard code generates unknown scancode errors. We want to
> > > > > > > know when users have keys that don't work.
> > > > > >
> > > > > > All right, but what about the unknown WMI events? Those are the
> > > > > > bigger problem anyway, as at least one machine (the Latitude
> > > > > > XT2) can generate a lot of these messages for unknown reasons.
> > > > > > It doesn't appear that anyone has been making use of these
> > > > > > messages since we still only support one event. Would you object to
> > demoting that one?
> > > > >
> > > > > Those can probably be ignored, but again it would be nice to find
> > > > > out what they actually mean so we know whether we can do anything
> > with them.
> > > > > Any chance of you being able to work with Dell on that?
> > > >
> > > > I'll see what I can do.
> > >
> > > Great, thanks. If we don't work out what they are then we can
> > > certainly drop the error - I agree that telling the user about
> > > something that just confuses us isn't helpful.
> > 
> > I've tried a few different avenues trying to get this informatin out of Dell, but
> > so far I've gotten very little. 0x11 is a status change event notification,
> > apparently sent when there are changes to things like battery charge status,
> > ALS level, etc. I haven't received any information about how to interpret the
> > payload, and what little Dell kit I have doesn't seem to send this event.
> > 
> > I've received no informtion at all on the 0xf event. The only thing I really
> > know about is from a user report stating that it's seen on the
> > XT2 when opening and closing the lid in notebook orientation.
> > 
> > I can take further action if Dell becomes more forthcoming, but I'm not
> > holding out much hope at this point. So I can send a new patch demoting only
> > the WMI event message to debug, or I can silence it only for these specific
> > events. Do you have a preference?
> > 
> 
> My opinion would be to deprioritize the log level for now, if necessary. I am working on gathering more information on unhandled events and will submit a patch in the next few weeks to handle them.

Thanks for the response, Rez. It will be nice to have those events
supported.

I was only advocating dropping the priority of the message because it
looked like nothing would ever be done about them. If you'll be seending
a patch soon-ish then we can just demote it in Ubuntu to stop the bug
reports while we wait for the patch.

Seth
