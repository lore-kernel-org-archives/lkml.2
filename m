Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab0JMLgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 07:36:44 -0400
Received: from canuck.infradead.org ([134.117.69.58]:55451 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab0JMLgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 07:36:43 -0400
Date: Wed, 13 Oct 2010 07:36:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/18] fs: rework icount to be a locked variable
Message-ID: <20101013113643.GD19456@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286928961-15157-8-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -		atomic_inc(&inode->i_count);
> +		spin_lock(&inode->i_lock);
> +		inode->i_ref++;
> +		spin_unlock(&inode->i_lock);

Why isn't this using iref?

> +		spin_lock(&inode->i_lock);
> +		inode->i_ref++;
> +		spin_unlock(&inode->i_lock);

Same here and in a couple of others.

Hmm, I guess because the i_lock later covers other things around.
But it still looks a bit weird.

Except for this stuff the patch looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>
