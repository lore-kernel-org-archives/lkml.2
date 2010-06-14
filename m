Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab0FNPX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:23:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60261 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0FNPX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:23:56 -0400
Date: Mon, 14 Jun 2010 11:23:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, josef@redhat.com, jeffmerkey@gmail.com
Subject: Re: [PATCH 4/5] fsfreeze: switch to using super methods everywhere
Message-ID: <20100614152355.GD32354@infradead.org>
References: <1276154395-24766-1-git-send-email-david@fromorbit.com>
 <1276154395-24766-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276154395-24766-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 05:19:53PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> freeze/thaw_bdev are now just trivial wrappers around
> freeze/thaw_super(). Convert all users of the bdev interfaces to use
> the superblock interfaces instead, and remove the bdev interfaces.

This requires exporting get_active_super.  Buit if we want to keep suppoting
freezing of unmounted block devices we need to keep the helpers anyway.
