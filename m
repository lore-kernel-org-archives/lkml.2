Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab0FNPWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:22:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60122 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0FNPWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:22:20 -0400
Date: Mon, 14 Jun 2010 11:22:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, josef@redhat.com, jeffmerkey@gmail.com
Subject: Re: [PATCH 3/5] fsfreeze: freeze_super and thaw_bdev don't play well
 together
Message-ID: <20100614152219.GC32354@infradead.org>
References: <1276154395-24766-1-git-send-email-david@fromorbit.com>
 <1276154395-24766-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276154395-24766-4-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This breaks the "feature" that we can freeze a block device that doesn't
have a filesystem mounted yet.  For filesystems using get_sb_bdev that
prevents a new filesystem to be mounted on them.

I'm not sure it's a particularly useful feature, but it's been there
since day 1 of the freeze support.  The easiest way to not break it
would be to keep the per-sb freeze count only for that case and only
check it during mount.
