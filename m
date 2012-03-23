Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919Ab2CWUSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 16:18:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756605Ab2CWUSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 16:18:33 -0400
Date: Fri, 23 Mar 2012 16:18:20 -0400
From: David Teigland <teigland@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, bpoirier@suse.de
Subject: Re: GFS2: Pre-pull patch posting (merge window)
Message-ID: <20120323201820.GE24746@redhat.com>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
 <4F674696.7030602@xenotime.net>
 <1332169153.2689.20.camel@menhir>
 <4F674E4F.5080904@xenotime.net>
 <1332171247.2689.28.camel@menhir>
 <20120323194152.GD24746@redhat.com>
 <4F6CD7AD.9030306@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6CD7AD.9030306@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 01:06:05PM -0700, Randy Dunlap wrote:
> >> GFS2_FS selects DLM (if GFS2_FS_LOCKING_DLM, which is enabled).
> >> GFS2_FS selects IP_SCTP if DLM_SCTP, which is not enabled and not
> >> used anywhere else in the kernel tree AFAICT.
> >> DLM just always selects IP_SCTP.
> > 
> > Here's what we have now:
> > 
> > config GFS2_FS
> >         tristate "GFS2 file system support"
> >         depends on (64BIT || LBDAF)
> >         select DLM if GFS2_FS_LOCKING_DLM
> >         select CONFIGFS_FS if GFS2_FS_LOCKING_DLM
> >         select SYSFS if GFS2_FS_LOCKING_DLM
> >         select IP_SCTP if DLM_SCTP
> >         select FS_POSIX_ACL
> >         select CRC32
> >         select QUOTACTL
> > 
> > menuconfig DLM
> >         tristate "Distributed Lock Manager (DLM)"
> >         depends on EXPERIMENTAL && INET
> >         depends on SYSFS && CONFIGFS_FS && (IPV6 || IPV6=n)
> >         select IP_SCTP
> > 
> > Why does gfs2 Kconfig bother with SCTP at all?  It seems that line should
> > just be removed.  I'll also remove EXPERIMENTAL.  I don't understand the
> > vagaries of Kconfig, so a dumb question, how could sctp_do_peeloff
> > possibly be undefined if we're selecting SCTP.
> 
> What is selecting SCTP?  DLM?  so GFS2 selects DLM, but selects
> don't follow dependency chains.  Also, the "select IP_SCTP if DLM_SCTP"
> in GFS2 is meaningless since there is no DLM_SCTP.

https://lkml.org/lkml/2012/3/8/222 seems to have caused this by adding
the new dependency on the sctp module without any Kconfig changes.

Should that patch have added depends IP_SCTP to the dlm and gfs2?

