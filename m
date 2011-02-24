Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab1BXA0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:26:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006Ab1BXA0M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:26:12 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Feb 2011 16:25:23 -0800
Message-ID: <AANLkTimTzjHkVQGPBRXrcb6M1_xaDY_==pB5ZyB9CJpR@mail.gmail.com>
Subject: btusb autosuspend (was Re: Linux 2.6.38-rc6)
To: Marcel Holtmann <marcel@holtmann.org>, Matthew Garrett <mjg@redhat.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. Is there any reason we shouldn't revert commit
556ea928f78a390fe16ae584e6433dff304d3014 given the regression?

It apparently had problems before too, and caused autosuspend to be
disabled entirely, judging at least by

  https://bugzilla.redhat.com/show_bug.cgi?id=528744

but there's obviously the comment about "those should be fixed now".
Apparently there are more issues.

I have no idea whether this is a USB-level issue, or a driver-level
one. There are no comments about exactly what fixed the input device
issues. So I'm adding both BT and USB people to the discussion.

                    Linus

On Wed, Feb 23, 2011 at 1:43 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
> I just encountered this reported bug using Bluetooth Intermec scanners
> and discovered that the recent kernel has the same problem as reported
> below.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=26182  ... the bluetooth
> devices would just stop responding after a while.
>
> [ 4533.361959] btusb 8-1:1.0: no reset_resume for driver btusb?
> [ 4533.361964] btusb 8-1:1.1: no reset_resume for driver btusb?
>
> It seems to that Fedora doesn't feel this is a big problem, but for
> production systems, it's a big deal as the scanners can't connect to
> the server.
>
> Seems to relate to this commit. The workabout is to set
> usbcore.autosuspend=-1 as command line options, but as this is not
> working as intended, then it should be either be fixed or reverted.
>
> Thanks,
> Jeff.
>
>
>
> commit 556ea928f78a390fe16ae584e6433dff304d3014
> Author: Matthew Garrett <mjg@redhat.com>
> Date:   Thu Sep 16 13:58:15 2010 -0400
>
>    Bluetooth: Enable USB autosuspend by default on btusb
>
>    We've done this for a while in Fedora without any obvious problems other
>    than some interaction with input devices. Those should be fixed now, so
>    let's try this in mainline.
>
>    Signed-off-by: Matthew Garrett <mjg@redhat.com>
>    Acked-by: Marcel Holtmann <marcel@holtmann.org>
>    Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
>
