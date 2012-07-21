Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab2GUIGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 04:06:55 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:51332 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab2GUIGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 04:06:49 -0400
X-Greylist: delayed 1987 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Jul 2012 04:06:49 EDT
Message-ID: <1342856010.21788.47.camel@ted>
Subject: Re: sysfs permissions on dynamic attributes (led delay_on and
 delay_off)
From: Richard Purdie <richard.purdie@linuxfoundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>, lkml <linux-kernel@vger.kernel.org>,
        Bryan Wu <bryan.wu@canonical.com>
Date: Sat, 21 Jul 2012 08:33:30 +0100
In-Reply-To: <20120721040816.GA7313@kroah.com>
References: <CAMbhsRTX=t4UMfmrJRyXidSTWXvaC5L9aFdTFL03wYYKrUE5qw@mail.gmail.com>
	 <20120721040816.GA7313@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 21:08 -0700, Greg KH wrote:
> On Fri, Jul 20, 2012 at 05:46:14PM -0700, Colin Cross wrote:
> > I'm trying to use the standard ledtrig-timer.c code to handle led
> > blinking for notifications on an Android device, and I'm hitting some
> > issues with setting permissions on the dynamically created delay_on
> > and delay_off attributes.  For most sysfs files, we have userspace
> > uevent parser that watches for device add notifications and
> > chowns/chmods attributes.  This doesn't work for delay_on and
> > delay_off, because they are created later, when "timer" is written to
> > the trigger attribute.  There is no uevent when the new files are
> > created, and sysfs doesn't support inotify, so I don't see any way to
> > receive an event to set the permissions.  This issue exists any time
> > that device_create_file is called after device_add.
> > 
> > What is the appropriate way to get an event to set the permissions?
> > Add inotify support for sysfs file creation?  Send a KOBJ_CHANGE
> > uevent in device_create_file?
> 
> No.
> 
> > Send a KOBJ_CHANGE uevent from the driver after calling
> > device_create_file?
> 
> Yes.
> 
> > Dynamically create a timer device under /sys/class/leds/<led> so a new
> > add uevent gets sent?
> 
> Ick.
> 
> > Promote blinking to be a core led feature instead of a trigger, so the
> > files are always present?
> 
> That's the best thing, why not just do that?

This implies we should make every trigger a core led feature and
effectively do away with triggers. I'm not sure that makes sense.

Cheers,

Richard

