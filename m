Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab1J1RX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:23:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38367 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab1J1RXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:23:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate interfaces
Date: Fri, 28 Oct 2011 19:26:27 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Greg KH <greg@kroah.com>
References: <Pine.LNX.4.44L0.1110281058190.2175-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1110281058190.2175-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110281926.27467.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 28, 2011, Alan Stern wrote:
> On Fri, 28 Oct 2011, Rafael J. Wysocki wrote:
> 
> > > > Now, in the end, I think our approach makes more sense in a general 
> > > > setting.  The Android approach is okay for a restricted environment 
> > > > where you know beforehand exactly which devices will be wakeup-capable 
> > > > and which wakeup events will be monitored by userspace programs.  But 
> > > > for the whole range of Linux-based systems, the kernel can't rely on 
> > > > such information.
> > > 
> > > I think that is exactly right.  The Android code is understandable written
> > > to particularly suit the Android context and may not be generally applicable.
> > 
> > I'm not sure why the heck this makes any difference.  For now, there doesn't
> > seem to be no one else who needs that functionality.  If there were people
> > like that we'd see some concurrent approaches appearing, but for now it's only
> > us considering the alternatives _theoretically_.
> > 
> > Moreover, if somebody who needs similar functionality and for whom the Android
> > stuff is not sufficient appears in the future, I don't see why not to address
> > his needs _at_ _that_ _time_ instead of trying to anticipate them (which is
> > kind of useless anyway, because we have no idea what those needs may be).
> 
> You're missing the point.  There could easily be situations where the
> Android kernel will block suspend but a more general system should
> _not_ block it.  Behavior that is appropriate in an Android phone might
> not be appropriate in, say, a desktop system.
> 
> If we duplicate the Android functionality then people (who may or may
> not theoretically want it now) might find that they _don't_ want the
> new behavior.

Where is it said that is has to be mandatory?

> > > I think the Android folk understand this and don't insist on having exactly
> > > that code merged.  They just want the same functionality with the same
> > > efficiency without unnecessary change to user-space.
> > 
> > The whole problem is that the Android code is proven to work on lots and
> > lots of systems and whatever else we can come up with will not be.
> 
> But it seems likely that the Android code, which has been tested on 
> only one kind of system, will _not_ work correctly on other kinds of 
> systems.
> 
> Assuming we do go ahead and merge some form of the Android code, we
> must make sure that it won't have bad effects in situations where it's
> not needed or wanted.

Yes, that clearly is what we must do.

> This means more than configuring it away with Kconfig.  When it is present,
> there has to be a way to control its behavior in some detail.

I entirely agree.

Thanks,
Rafael
