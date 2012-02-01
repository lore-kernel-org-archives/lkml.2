Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab2BAW66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:58:58 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49110 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754354Ab2BAW65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:58:57 -0500
X-Sasl-enc: 2LQ46RCaaKSpJ/ogzGg1XcnIH2RBi2S5WiGafhZMa76L 1328137136
Date: Wed, 1 Feb 2012 14:49:18 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] sysfs:  Optionally count subdirectories to support buggy
 applications
Message-ID: <20120201224918.GA2868@kroah.com>
References: <20120130221059.26ab5edf@pyramind.ukuu.org.uk>
 <20120130222717.GA6393@kroah.com>
 <m18vkoirv9.fsf@fess.ebiederm.org>
 <4F27C6EB.2070305@suse.cz>
 <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org>
 <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <20120201222441.GB2333@kroah.com>
 <m139auxjfz.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m139auxjfz.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 02:44:32PM -0800, Eric W. Biederman wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > On Wed, Feb 01, 2012 at 02:21:59PM -0800, Eric W. Biederman wrote:
> >> 
> >> lm_sensors and possibly other applications get confused if all sysfs
> >> directories return nlink == 1.  The lm_sensors code that got confused
> >> was just wrong and a fixed version of lm_sensors should be released
> >> shortly.
> >> 
> >> There may be other applications that have problems with sysfs return
> >> nlink == 1 for directories.  To allow people to continue to use old
> >> versions of userspace with new kernels add to sysfs a compile time
> >> option to maintain mostly precise directory counts for those people who
> >> don't mind the cost.
> >> 
> >> I have moved where we keep nlink in sysfs_dirent as compared to previous
> >> versions of subdirectory counting to a location that packs better.
> >> 
> >> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> >> ---
> >>  fs/sysfs/Kconfig |   15 +++++++++++++++
> >>  fs/sysfs/dir.c   |    8 ++++++++
> >>  fs/sysfs/inode.c |    2 ++
> >>  fs/sysfs/sysfs.h |   38 ++++++++++++++++++++++++++++++++++++++
> >>  4 files changed, 63 insertions(+), 0 deletions(-)
> >> 
> >> diff --git a/fs/sysfs/Kconfig b/fs/sysfs/Kconfig
> >> index 8c41fea..9b403e9 100644
> >> --- a/fs/sysfs/Kconfig
> >> +++ b/fs/sysfs/Kconfig
> >> @@ -21,3 +21,18 @@ config SYSFS
> >>  	example, "root=03:01" for /dev/hda1.
> >>  
> >>  	Designers of embedded systems may wish to say N here to conserve space.
> >> +
> >> +config SYSFS_COUNT_LINKS
> >> +	bool "sysfs count subdirectoires to support buggy applications"
> >> +	default n
> >
> > As we don't want to break things, this should be default y, right?
> 
> The new behavior is backwards compatible.  What the new behavior is not
> is bug compatible.  So nothing *should* break.

"should", but you really don't know, as all we have is one report so
far.

> Furthermore the breaking we have seen so far is limited to just
> lm_sensors.  That is exactly one program that is not a server failing to
> start.  That seems pretty minor in the worst case.
> 
> So I really don't expect anyone who ships 3.4 to enable this option.

What about users who use a new kernel on old userspace, which happens
all the time (i.e. all the kernel developers themselves)?

> I have written the option solely so that in case my assessment turns out
> to be wrong there is already a tested solution.  I have been through the
> pain of not being able to upgrade/test a new kernel because of a
> backwards incompatible change and it can be very unpleasant.

I'd really prefer this to be default 'y', and if a distro knows it can
turn it off to save time/space, it can.

thanks,

greg k-h
