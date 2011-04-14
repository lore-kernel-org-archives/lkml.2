Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955Ab1DNSbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:31:52 -0400
Received: from kroah.org ([198.145.64.141]:47714 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933016Ab1DNSbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:31:48 -0400
Date: Thu, 14 Apr 2011 11:27:37 -0700
From: Greg KH <greg@kroah.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <gregkh@suse.de>, Dan Rosenberg <drosenberg@vsecurity.com>,
        linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [Stable-review] [18/74] xfs: prevent leaking
 uninitialized stack memory in FSGEOMETRY_V1
Message-ID: <20110414182737.GB12732@kroah.com>
References: <20110413155144.895499184@clark.kroah.org>
 <1302749686.5282.659.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302749686.5282.659.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 03:54:45AM +0100, Ben Hutchings wrote:
> On Wed, 2011-04-13 at 08:50 -0700, Greg KH wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Dan Rosenberg <drosenberg@vsecurity.com>
> > 
> > commit c4d0c3b097f7584772316ee4d64a09fe0e4ddfca upstream.
> > 
> > The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
> > xfs_fs_geometry() with a version number of 3.  This code path does not
> > fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
> > the leaking of four bytes of uninitialized stack data to potentially
> > unprivileged callers.
> [...]
> 
> This caused a serious regression and requires a second fix:
> 
> commit af24ee9ea8d532e16883251a6684dfa1be8eec29
> Author: Alex Elder <aelder@sgi.com>
> Date:   Tue Mar 1 17:50:00 2011 +0000
> 
>     xfs: zero proper structure size for geometry calls

Thanks for letting me know, I've queued up this patch as well.

greg k-h
