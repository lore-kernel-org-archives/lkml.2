Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034Ab2GUEIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 00:08:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45339 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2GUEIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 00:08:24 -0400
Date: Fri, 20 Jul 2012 21:08:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Colin Cross <ccross@android.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: sysfs permissions on dynamic attributes (led delay_on and
 delay_off)
Message-ID: <20120721040816.GA7313@kroah.com>
References: <CAMbhsRTX=t4UMfmrJRyXidSTWXvaC5L9aFdTFL03wYYKrUE5qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRTX=t4UMfmrJRyXidSTWXvaC5L9aFdTFL03wYYKrUE5qw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 05:46:14PM -0700, Colin Cross wrote:
> I'm trying to use the standard ledtrig-timer.c code to handle led
> blinking for notifications on an Android device, and I'm hitting some
> issues with setting permissions on the dynamically created delay_on
> and delay_off attributes.  For most sysfs files, we have userspace
> uevent parser that watches for device add notifications and
> chowns/chmods attributes.  This doesn't work for delay_on and
> delay_off, because they are created later, when "timer" is written to
> the trigger attribute.  There is no uevent when the new files are
> created, and sysfs doesn't support inotify, so I don't see any way to
> receive an event to set the permissions.  This issue exists any time
> that device_create_file is called after device_add.
> 
> What is the appropriate way to get an event to set the permissions?
> Add inotify support for sysfs file creation?  Send a KOBJ_CHANGE
> uevent in device_create_file?

No.

> Send a KOBJ_CHANGE uevent from the driver after calling
> device_create_file?

Yes.

> Dynamically create a timer device under /sys/class/leds/<led> so a new
> add uevent gets sent?

Ick.

> Promote blinking to be a core led feature instead of a trigger, so the
> files are always present?

That's the best thing, why not just do that?

thanks,

greg k-h
