Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab2KUAKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:10:01 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:49615 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159Ab2KUAKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:10:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEIAOYarFB5LbLL/2dsb2JhbABEvFSGABdzgh4BAQQBOhweBQULCAMYLhQlAyETiAcFvykUjCCEYgOVfZBCgwOBSSQ
Date: Wed, 21 Nov 2012 11:09:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH RFC 0/12] Final userns conversions
Message-ID: <20121121000952.GL2591@dastard>
References: <87pq38wimv.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pq38wimv.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 04:42:16AM -0800, Eric W. Biederman wrote:
> 
> This patchset contain the basic user namespace changes for filesystems
> that have needed nontrivial work.  Along with the 2 patches that depend
> on these changes.
> 
> I belive these patches to be correct for allowing the remaining
> filesystems to work in the presence of user namespaces.  At the same
> time I would like to give all of these much deeper scrutiny, just
> because there is so much going on.  Unfortunately these patches
> individually are not obviously correct.
> 
> Since I won't have much time until after Thanksgiving and because the
> merge window is looming I figure I will put these changes out there and
> let people see I am looking at these changes, and see if anyone happens
> to spot anything.

The XFS stuff is non-trivial, causes on-disk format changes and
likely breaks xfsdump/xfsrestore, so the XFS patch is a no-go until
that is sorted out.

Given the short time until the merge window and that the XFS patch
needs to be significantly revised, it's already too late for the XFS
changes to be considered for the 3.8 merge window.  Hence I'd
suggest that you are going to be targeting 3.9 for the XFS changes.

> If I can figure out how to responsibly get these changes into linux-next
> I want to get these changes into linux-next so that user namespace bugs
> show up in allyesconfig builds.

The XFS changes definitely need to be staged through the XFS tree
given the complexity of the changes, the amount of validation that
is required. Also, it is likely that there are significant conflicts
against changes already staged for 3.8, so getting it upstream
through the XFS tree is the only option that I'd consider
acceptible...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
