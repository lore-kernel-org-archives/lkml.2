Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab1LOU4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 15:56:41 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59282 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759225Ab1LOU4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 15:56:40 -0500
X-Sasl-enc: QGlkOrCzxKj4o3lWOtEscOdd2DjcerY69v/2oYtDhjIA 1323982599
Subject: Re: chroot(2) and bind mounts as non-root
From: Colin Walters <walters@verbum.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LKML <linux-kernel@vger.kernel.org>, alan@lxorguk.ukuu.org.uk,
        morgan@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        luto@mit.edu, kzak@redhat.com, Steve Grubb <sgrubb@redhat.com>
Date: Thu, 15 Dec 2011 15:56:18 -0500
In-Reply-To: <20111212231149.GA16408@hallyn.com>
References: <1323280461.10724.13.camel@lenny>
	 <20111210052945.GA14931@hallyn.com> <1323708089.29338.39.camel@lenny>
	 <20111212231149.GA16408@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323982580.31563.15.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 23:11 +0000, Serge E. Hallyn wrote:

> Look at the cap_get_bound.3 manpage, and look for CAP_IS_SUPPORTED.
> If you start at CAP_LAST_CAP and keep going up/down depending on whether
> it was support or not it shouldn't take too long to find the last
> valid value.  Not ideal, but should be reliable.

Blah =/  I think I'll just rely on the MS_NOSUID bind mount for now.

> I haven't taken a critical look at the mount code but other than that
> it seems reasonable and useful to me!  Thanks.

Can you link me to any discussion of how the user namespace stuff you're
working on would enable any of this (chroot, bind mounts) to be
available to "unprivileged" users?  Is it that once a non-uid 0 process
enters a new namespace, when executing a setuid 0 binary from the
filesystem, because that binary is from a different user namespace, the
setuid bits don't apply?

What does it even mean for a file to be "owned" by a user namespace -
unless you're talking about patching e.g. ext4 to persist namespaces
somehow.

Where I'd ultimately like to get is having this utility in util-linux,
but before I propose that I'd like to have a good idea what the
possibilities are with user namespaces.

The more I think about this though, the more I am a big fan of what the
OpenWall people are doing - if it gets me chroot as a user, I am totally
on board with just removing all setuid binaries.  We're already fairly
far along on doing that in GNOME by using PolicyKit mechanisms anyways.


