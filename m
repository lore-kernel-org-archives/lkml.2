Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3AGUmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 15:42:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623Ab3AGUmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:42:35 -0500
Date: Mon, 7 Jan 2013 15:42:20 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: gregkh@linuxfoundation.org, stern@rowland.harvard.edu
Cc: laurent.pinchart@ideasonboard.com, mdharm-usb@one-eyed-alien.net,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: USB autosuspend vs. URB submission
Message-ID: <20130107204220.GB12363@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We've had a few reports in Fedora of users hitting the WARN_ONCE in
drivers/usb/core/urb.c that prints a warning about a usb_submit_urb
being called on an active URB.  One of them[1] is from the ums_realtek
driver and the other[2] is from the uvcvideo driver.  However, I noticed
that in both instances it seems the devices were coming back from what I
think is autosuspend.

I didn't immediately find any similar reports, and to my rather
inexperienced eyes the drivers didn't seem to be doing anything clearly
wrong.  I'm wondering if anyone has some possible ideas for debugging
and whether or not this might be a general issue?

The backtraces can be found in the bugs.  I've ommitted them here for
brevity, but if someone hates bugzilla that much I'd be happy to send
them along.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=889286
[2] https://bugzilla.redhat.com/show_bug.cgi?id=879462
