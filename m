Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0FNPZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:25:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60354 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0FNPZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:25:02 -0400
Date: Mon, 14 Jun 2010 11:25:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, josef@redhat.com, jeffmerkey@gmail.com
Subject: Re: [PATCH 5/5] fsfreeze: move emergency thaw code to fs/super.c
Message-ID: <20100614152502.GE32354@infradead.org>
References: <1276154395-24766-1-git-send-email-david@fromorbit.com>
 <1276154395-24766-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276154395-24766-6-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 05:19:54PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It makes no sense having the emergency thaw code in fs/buffer.c when all of
> it's operations are one superblocks and the code it executes is all in
> fs/super.c. Move the code there and clean it up.

> +static void thaw_super_emergency(struct super_block *sb, void *unused)
> +{
> +
> +	if (sb->s_bdev) {
> +		char b[BDEVNAME_SIZE];
> +		printk(KERN_WARNING "Emergency Thaw on %s.\n",
> +						bdevname(sb->s_bdev, b));
> +	}
> +	while (!__thaw_super(sb, 1));

Please move the ; to a separate line to make the loop better redable.

