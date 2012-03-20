Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab2CTJqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 05:46:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab2CTJqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 05:46:44 -0400
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
Date: Tue, 20 Mar 2012 09:47:00 +0000
Message-ID: <1332236820.2764.1.camel@menhir>
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
Since the pending patch set doesn't affect the Kconfig at all, I don't
think that this issue needs to hold up merging the GFS2 tree. We'll
follow up with a fix for this later on,

Steve.


