Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab0JHKDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:03:51 -0400
Received: from canuck.infradead.org ([134.117.69.58]:54455 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab0JHKDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:03:50 -0400
Date: Fri, 8 Oct 2010 06:03:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
Message-ID: <20101008100346.GA27737@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-16-git-send-email-david@fromorbit.com>
 <20101008095658.GA19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008095658.GA19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 10:56:58AM +0100, Al Viro wrote:
> FWIW, that one is begging to be split; what I mean is that there are
> two classes of callers; ones that will set i_ino themselves anyway
> and ones that really want i_ino invented.  Two functions?

There's no reason to add i_ino before adding it to the per-sb list,
we don't do so either for inodes acquired via iget.  The fix is simply
to stop assigning i_ino in new_inode and call the helper to get it in
the place that need it after the call to new_inode.  Later we can
even move to a lazy assignment scheme where needed.  I'd also really
like to get a grip on why the simple counters if fine for some
filesystems while we need iunique() for others.

