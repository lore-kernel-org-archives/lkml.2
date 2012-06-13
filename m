Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab2FMXvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 19:51:43 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:24411 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732Ab2FMXvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 19:51:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0JABMn2U95LAcV/2dsb2JhbABFtA4EgTCBCIIYAQEFOhwjEAgDDgouFCUDIROICgy6SBSLHUmFSAOVIIETiBKGWIJy
Date: Thu, 14 Jun 2012 09:51:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com
Subject: Re: [PATCH 0/2] Add FALLOC_FL_ZERO_RANGE to fallocate
Message-ID: <20120613235131.GW22848@dastard>
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
 <20120613013549.GO22848@dastard>
 <20120613033052.GT22848@dastard>
 <4FD82F89.80106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD82F89.80106@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 08:13:29AM +0200, Paolo Bonzini wrote:
> Il 13/06/2012 05:30, Dave Chinner ha scritto:
> >> > 
> >> > Also, a minor nit, but you should credit where this code has
> >> > originated from in the commit messages, and describe the use case
> >> > for requiring it. i.e. based on:
> >> > 
> >> > http://permalink.gmane.org/gmane.linux.file-systems/62449
> 
> Interesting, I didn't know this---I wrote the code from scratch.
> 
> I took the description from the man pages ("This operation is a fast
> method of overwriting any from the range specified with zeros without
> removing any blocks or having to write zeros to disk"), so perhaps those
> will have to be patched as well.

The first line of the man page description is the important one:

$ man 3 xfsctl
.....
XFS_IOC_ZERO_RANGE
      This  command is used to convert a range of a file to zeros
      without issuing data IO. ....

The rest of the description is details about the implementation in
XFS, so users have some idea what to expect in terms or behaviour.
The line that you quoted:

	This operation is a fast method of overwriting any from the
	range specified with zeros without removing any blocks or
	having to write zeros to disk.

describes how the implementation is different from hole punching
(i.e XFS_IOC_UNRESVSP).  All the stuff about unwritten extents is
copied directly from the about XFS_IOC_RESVSP preallocation
description to provide consistent information in the man page.

The XFS_IOC_ZERO_RANGE man page is not a requirements specification
- it's user-level documentation. Yes, it describes the
implementation, but does not convey any of the reasons that the
functionality was implemented that way. Hence using that as the
requirements spec for equivalent fallocate functionality will miss
the mark...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
