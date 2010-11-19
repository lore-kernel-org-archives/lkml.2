Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0KSPlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:41:22 -0500
Received: from THUNK.ORG ([69.25.196.29]:56221 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab0KSPlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:41:21 -0500
Date: Fri, 19 Nov 2010 10:41:19 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Message-ID: <20101119154119.GF10039@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	hch@infradead.org, sandeen@redhat.com
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 08:36:48AM +0100, Lukas Czerner wrote:
> There was concern that FITRIM ioctl is not common enough to be included
> in core vfs ioctl, as Christoph Hellwig pointed out there's no real point
> in dispatching this out to a separate vector instead of just through
> ->ioctl.
> 
> So this commit removes ioctl_fstrim() from vfs ioctl and trim_fs
> from super_operation structure.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Trying to redirect this thread back to the original patches....

What do people think?  Should I try to push these two patches to Linus
now, to make it easier for other file systems who might be interested
in implementing FITRIM functionality?

Or should I wait until the 2.6.37-rc1 window?

We're at -rc3, so a change like this is a bit late, but so far no one
else is using trim_fs besides ext4, and it will make life easier for
other file systems, so I'm willing to try pushing this to Linus if
there is consensus from other fs developers.

						- Ted
