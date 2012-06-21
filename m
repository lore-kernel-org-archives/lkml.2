Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab2FUNuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 09:50:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38531 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759686Ab2FUNtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 09:49:47 -0400
Date: Thu, 21 Jun 2012 06:49:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v2)
Message-ID: <20120621134942.GA8401@kroah.com>
References: <1339391600-17815-1-git-send-email-ming.lei@canonical.com>
 <20120615220343.GA8928@kroah.com>
 <CACVXFVO6h6wiHdTwVcjQLNtncO+ezVX3RJZPVenHEmhHjErRhg@mail.gmail.com>
 <20120618222550.GB11737@kroah.com>
 <CACVXFVOr1mnjaEoGpc3O_MDuvi_KHTXtsEBQ7LLoaeWxWRa0aQ@mail.gmail.com>
 <20120620223754.GA5864@kroah.com>
 <CACVXFVNP4HJwtjgAD=D7Fv7NW2j1aHj55X8j-4qhpBZTcw2+7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACVXFVNP4HJwtjgAD=D7Fv7NW2j1aHj55X8j-4qhpBZTcw2+7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 09:21:08AM +0800, Ming Lei wrote:
> On Thu, Jun 21, 2012 at 6:37 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, Jun 19, 2012 at 10:00:36AM +0800, Ming Lei wrote:
> 
> >> so I marked it as -stable because I have explained how the race can be
> >> exploited in reality.
> >
> > Ok, but as this has been there since when, 2.5, I'll refrain from
> > marking it this way, as no one has reported a real problem like this
> > before.
> 
> So have you agreed on keeping Cc: stable in v3?

No.

> >> I still have more many examples in kernel about timeout value...
> >
> > Yes, I know this, but now you are putting a limit on the amount of time
> 
> No, I don't put a limit on it, see my below explanation.
> 
> > a probe function can take, when before, we have never had one.  That's
> > not something to be taken lightly, and is one I know is not true.
> >
> >> > Why not just do a real lock and try for forever?
> >>
> >> IMO, there are two advantages not just doing a real lock for forever:
> >>
> >> - avoiding buggy device/driver to hang the system
> >> - with trylock, we can log the buggy device so that it is a bit
> >> easier to troubleshoot the buggy drivers, suppose the bug is
> >> only triggered 1 time in one year or more
> >
> > No, just fix the driver, I don't want to put a time limit on how long
> 
> Surely we need to fix the driver, but the problem is that it may be very
> difficult to fix the driver without the log introduced in the patch, so why
> not take it without obvious side effect?

Because nothing is wrong with the driver if it takes that long, it's not
"broken" at all, because we have never made the rule that a probe
function has to complete in a specific amount of time.

We also have not made the rule that a shutdown will complete in a
specific amount of time either, so there is no problem if that takes a
long time as well.

greg k-h
