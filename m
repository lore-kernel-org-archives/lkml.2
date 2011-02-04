Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab1BDUH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:07:26 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47363 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751996Ab1BDUHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:07:25 -0500
Date: Fri, 4 Feb 2011 15:07:24 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: "Rafael J. Wysocki" <rjw@suse.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
In-Reply-To: <4D4C55B7.4010005@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1102041506090.1877-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Feb 2011, Jiri Slaby wrote:

> On 02/04/2011 08:33 PM, Alan Stern wrote:
> > On Fri, 4 Feb 2011, Jiri Slaby wrote:
> > 
> >>>> It seems to suffice... No hangs still. Should I enable pm_async back
> >>>> again to confirm the issue is still present?
> >>>
> >>> Yes, please, it would be good to know for sure.
> >>
> >> Ok, confirmed right now :).
> >>
> >> I disabled pm_async for USB again. What do you suggest next?
> > 
> > What happens if you leave pm_async enabled but unplug all the USB 
> > devices before suspending?
> 
> Then I cannot suspend at all (ENOINPUTDEVICE)... And this would be
> painful as the bug occurs once a week or so.

You can suspend using a remote network login.  Agreed, this would be 
painful.

> > If there are any USB devices you can't 
> > unplug, you can get an equivalent result by unconfiguring the root 
> > hubs:
> > 
> > 	for a in /sys/bus/usb/devices/usb* ; do
> > 		echo 0 >$a/bConfigurationValue
> > 	done
> 
> Well, I can put this into suspend/resume scripts. What's the opposite
> operation? 1 > $a/bConfigurationValue?

Yes.

Alan Stern

