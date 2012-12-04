Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab2LDUYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:24:22 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:53843 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943Ab2LDUYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:24:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgPAJ5avlB5LPYI/2dsb2JhbABEhUqyYYYDF3OCHgEBBTocIxAIAxguFCUDIROID8BzFIwjg2BhA5YCkEiDBg
Date: Wed, 5 Dec 2012 07:24:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: yangsheng <sickamd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, adilger@dilger.ca
Subject: Re: [PATCH] Update atime from future.
Message-ID: <20121204202416.GB9451@dastard>
References: <1354557399-6202-1-git-send-email-sickamd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354557399-6202-1-git-send-email-sickamd@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 01:56:39AM +0800, yangsheng wrote:
> Relatime should update the inode atime if it is more than a day in the
> future.  The original problem seen was a tarball that had a bad atime,
> but could also happen if someone fat-fingers a "touch".  The future
> atime will never be fixed.  Before the relatime patch, the future atime
> would be updated back to the current time on the next access.

So if someone accidentally changes time back a few days, access
times go backwards for everything? That doesn't sound right to me -
it's going to seriously screw up backups and other scanners that use
atime to determine "newly accessed files"....

IMO, if you fat-finger a manual atime update or use atimes direct
from tarballs, then that's your problem as a user and not the
responsibility of the kernel to magically fix for you....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
