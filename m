Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030360Ab2CWTmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:42:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486Ab2CWTl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:41:59 -0400
Date: Fri, 23 Mar 2012 15:41:52 -0400
From: David Teigland <teigland@redhat.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com
Subject: Re: GFS2: Pre-pull patch posting (merge window)
Message-ID: <20120323194152.GD24746@redhat.com>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
 <4F674696.7030602@xenotime.net>
 <1332169153.2689.20.camel@menhir>
 <4F674E4F.5080904@xenotime.net>
 <1332171247.2689.28.camel@menhir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332171247.2689.28.camel@menhir>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> on i386:
>
> ERROR: "sctp_do_peeloff" [fs/dlm/dlm.ko] undefined!
>
>
> GFS2_FS selects DLM (if GFS2_FS_LOCKING_DLM, which is enabled).
> GFS2_FS selects IP_SCTP if DLM_SCTP, which is not enabled and not
> used anywhere else in the kernel tree AFAICT.
> DLM just always selects IP_SCTP.

Here's what we have now:

config GFS2_FS
        tristate "GFS2 file system support"
        depends on (64BIT || LBDAF)
        select DLM if GFS2_FS_LOCKING_DLM
        select CONFIGFS_FS if GFS2_FS_LOCKING_DLM
        select SYSFS if GFS2_FS_LOCKING_DLM
        select IP_SCTP if DLM_SCTP
        select FS_POSIX_ACL
        select CRC32
        select QUOTACTL

menuconfig DLM
        tristate "Distributed Lock Manager (DLM)"
        depends on EXPERIMENTAL && INET
        depends on SYSFS && CONFIGFS_FS && (IPV6 || IPV6=n)
        select IP_SCTP

Why does gfs2 Kconfig bother with SCTP at all?  It seems that line should
just be removed.  I'll also remove EXPERIMENTAL.  I don't understand the
vagaries of Kconfig, so a dumb question, how could sctp_do_peeloff
possibly be undefined if we're selecting SCTP.

