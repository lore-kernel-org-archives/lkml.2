Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140Ab2CSPdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:33:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759094Ab2CSPdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:33:49 -0400
Subject: Re: GFS2: Pre-pull patch posting (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        teigland@redhat.com
In-Reply-To: <4F674E4F.5080904@xenotime.net>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
	 <4F674696.7030602@xenotime.net> <1332169153.2689.20.camel@menhir>
	 <4F674E4F.5080904@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 19 Mar 2012 15:34:07 +0000
Message-ID: <1332171247.2689.28.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2012-03-19 at 08:18 -0700, Randy Dunlap wrote:
> On 03/19/2012 07:59 AM, Steven Whitehouse wrote:
> 
> > Hi,
> > 
> > On Mon, 2012-03-19 at 07:45 -0700, Randy Dunlap wrote:
> >> On 03/19/2012 03:25 AM, Steven Whitehouse wrote:
> >>
> >>> Hi,
> >>>
> >>> Not a huge number of patches this time. Some notable new features
> >>> though:
> >>>  - Glock stats gathering (v. useful for performance analysis)
> >>>  - FITRIM ioctl support
> >>>  - Sorting the ordered write list (big performance increase when the workload
> >>>    doesn't result in the write requests being nicely ordered to start with)
> >>>
> >>> Plus a few clean ups, and bug fixes in addition,
> >>
> >>
> >>
> >> Hi,
> >>
> >> I reported a build error in linux-next 20120313, but it appears
> >> that mainline also needs the fix (when it's ready) since mainline
> >> gfs2 Kconfig selects DLM_SCTP, which does not exist.
> >>
> >> https://lkml.org/lkml/2012/3/13/456
> >>
> > 
> > Does the following fix the problem? If so then I'll roll that into the
> > tree before it gets pushed,
> > 
> 
> No, that's not sufficient:
> 
> warning: (GFS2_FS) selects DLM which has unmet direct dependencies (EXPERIMENTAL && INET && SYSFS && CONFIGFS_FS && (IPV6 || IPV6=n))
> warning: (DLM && GFS2_FS) selects IP_SCTP which has unmet direct dependencies (NET && INET && EXPERIMENTAL && (IPV6 || IPV6=n))
> 
> and
> 
> ERROR: "crc32c" [net/sctp/sctp.ko] undefined!
> 
> 
Hmm, ok. I'll look at this again. I'm not sure why DLM is still calling
itself EXPERIMENTAL since thats long since not been the case, maybe SCTP
still is, but I don't think GFS2 should be selecting EXPERIMENTAL
directly, anyway. It is rather easy to tie ones' self in knots with this
config language.... since GFS2_FS_LOCKING_DLM depends on NET && INET &&
(IPV6 || IPV6=n) && HOTPLUG then all those other deps must presumably be
set anyway, so I don't understand quite why DLM doesn't have those
available to it.

I'll dig around a bit and see if I can figure out whats going on here,

Steve.


> 
> 
> > 
> > diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
> > index c465ae0..f4e1c60 100644
> > --- a/fs/gfs2/Kconfig
> > +++ b/fs/gfs2/Kconfig
> > @@ -4,7 +4,7 @@ config GFS2_FS
> >  	select DLM if GFS2_FS_LOCKING_DLM
> >  	select CONFIGFS_FS if GFS2_FS_LOCKING_DLM
> >  	select SYSFS if GFS2_FS_LOCKING_DLM
> > -	select IP_SCTP if DLM_SCTP
> > +	select IP_SCTP if GFS2_FS_LOCKING_DLM
> >  	select FS_POSIX_ACL
> >  	select CRC32
> >  	select QUOTACTL
> > 
> > 
> 
> 
> 


