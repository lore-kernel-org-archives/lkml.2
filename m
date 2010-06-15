Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab0FOABa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 20:01:30 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:50286 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751188Ab0FOAB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 20:01:29 -0400
Date: Tue, 15 Jun 2010 10:01:07 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, josef@redhat.com, jeffmerkey@gmail.com
Subject: Re: [PATCH 3/5] fsfreeze: freeze_super and thaw_bdev don't play
 well together
Message-ID: <20100615000107.GJ6590@dastard>
References: <1276154395-24766-1-git-send-email-david@fromorbit.com>
 <1276154395-24766-4-git-send-email-david@fromorbit.com>
 <20100614152219.GC32354@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614152219.GC32354@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 11:22:19AM -0400, Christoph Hellwig wrote:
> This breaks the "feature" that we can freeze a block device that doesn't
> have a filesystem mounted yet.  For filesystems using get_sb_bdev that
> prevents a new filesystem to be mounted on them.
>
> I'm not sure it's a particularly useful feature, but it's been there
> since day 1 of the freeze support.  The easiest way to not break it
> would be to keep the per-sb freeze count only for that case and only
> check it during mount.

You mean the per-bdev freeze count, right? So freeze/thaw_bdev would
have to remain?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
