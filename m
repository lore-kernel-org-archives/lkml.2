Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab2DBPqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:46:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab2DBPqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:46:49 -0400
Subject: Re: GFS2: Pre-pull patch posting (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Benjamin Poirier <bpoirier@suse.de>, David Teigland <teigland@redhat.com>,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <4F79C733.60604@xenotime.net>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
	 <4F674696.7030602@xenotime.net> <1332169153.2689.20.camel@menhir>
	 <4F674E4F.5080904@xenotime.net> <1332171247.2689.28.camel@menhir>
	 <20120323194152.GD24746@redhat.com> <4F6CD7AD.9030306@xenotime.net>
	 <20120323201820.GE24746@redhat.com>
	 <20120323220618.GA30906@d2.synalogic.ca> <1332758662.2721.10.camel@menhir>
	 <4F79C733.60604@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 02 Apr 2012 16:47:06 +0100
Message-ID: <1333381626.2701.28.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2012-04-02 at 08:35 -0700, Randy Dunlap wrote:
> On 03/26/2012 03:44 AM, Steven Whitehouse wrote:
> 
> > Hi,
> > 
> > On Fri, 2012-03-23 at 18:06 -0400, Benjamin Poirier wrote:
> > [snip]
> >>
> >> Instead of trying to select everything in GFS2, how about doing it this way?
> >>
> >> [PATCH] gfs2: use depends instead of select in kconfig
> >>
> >> Avoids having to duplicate the dependencies of what is 'select'ed (and on
> >> down...)
> >>
> >> Those dependencies are currently incomplete, leading to broken builds with
> >> GFS2_FS_LOCKING_DLM=y and IP_SCTP=n.
> >>
> >> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
> >> ---
> >>  fs/gfs2/Kconfig |    7 ++-----
> >>  1 files changed, 2 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
> >> index c465ae0..eb08c9e 100644
> >> --- a/fs/gfs2/Kconfig
> >> +++ b/fs/gfs2/Kconfig
> >> @@ -1,10 +1,6 @@
> >>  config GFS2_FS
> >>  	tristate "GFS2 file system support"
> >>  	depends on (64BIT || LBDAF)
> >> -	select DLM if GFS2_FS_LOCKING_DLM
> >> -	select CONFIGFS_FS if GFS2_FS_LOCKING_DLM
> >> -	select SYSFS if GFS2_FS_LOCKING_DLM
> >> -	select IP_SCTP if DLM_SCTP
> >>  	select FS_POSIX_ACL
> >>  	select CRC32
> >>  	select QUOTACTL
> >> @@ -29,7 +25,8 @@ config GFS2_FS
> >>  
> >>  config GFS2_FS_LOCKING_DLM
> >>  	bool "GFS2 DLM locking"
> >> -	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && HOTPLUG
> >> +	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && \
> >> +		HOTPLUG && DLM && CONFIGFS_FS && SYSFS
> >>  	help
> >>  	  Multiple node locking module for GFS2
> >>  
> > 
> > That looks ok to me. I've put it in the GFS2 -fixes tree, and if
> > everybody is happy with that I'll send a pull request shortly,
> 
> 
> Can we get Benjamin's patch merged, please?
> linux-next is still having build errors without it.
> 

It is in the GFS2 -nmw tree now, so it will be in linux-next shortly.
I'll merge up the -fixes tree shortly, but I'm expecting one more patch
for that very shortly,

Steve.


