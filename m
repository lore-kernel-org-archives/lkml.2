Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2KRO31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:29:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34159 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2KRO30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:29:26 -0500
Date: Sun, 18 Nov 2012 06:29:20 -0800
From: Tejun Heo <tj@kernel.org>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] cuse: use mutex as registration lock instead of
 spinlocks
Message-ID: <20121118142920.GG7306@mtj.dyndns.org>
References: <1353152748-6867-1-git-send-email-dh.herrmann@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353152748-6867-1-git-send-email-dh.herrmann@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On Sat, Nov 17, 2012 at 12:45:47PM +0100, David Herrmann wrote:
> We need to check for name-collisions during cuse-device registration. To
> avoid race-conditions, this needs to be protected during the whole device
> registration. Therefore, replace the spinlocks by mutexes first so we can
> safely extend the locked regions to include more expensive or sleeping
> code paths.
> 
> Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
> @@ -114,14 +113,18 @@ static int cuse_open(struct inode *inode, struct file *file)
>  	int rc;
>  
>  	/* look up and get the connection */
> -	spin_lock(&cuse_lock);
> +	rc = mutex_lock_interruptible(&cuse_lock);

Well, the above can't hurt but it doesn't help anything either given
the narrow scope of the lock.  Eh well, I guess it's okay either way.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
