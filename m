Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab0JPH5e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:57:34 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41874 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440Ab0JPH52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:57:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBI9K
Date: Sat, 16 Oct 2010 18:57:21 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
Message-ID: <20101016075721.GS19147@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-16-git-send-email-david@fromorbit.com>
 <20101008095658.GA19804@ZenIV.linux.org.uk>
 <20101008100346.GA27737@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008100346.GA27737@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 06:03:46AM -0400, Christoph Hellwig wrote:
> On Fri, Oct 08, 2010 at 10:56:58AM +0100, Al Viro wrote:
> > FWIW, that one is begging to be split; what I mean is that there are
> > two classes of callers; ones that will set i_ino themselves anyway
> > and ones that really want i_ino invented.  Two functions?
> 
> There's no reason to add i_ino before adding it to the per-sb list,
> we don't do so either for inodes acquired via iget.  The fix is simply
> to stop assigning i_ino in new_inode and call the helper to get it in
> the place that need it after the call to new_inode.  Later we can

My approach in my tree is a new function like Al suggests, which
simply doesn't assign the ino. That keeps compatibility backward.

