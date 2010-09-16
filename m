Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0IPW0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:26:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:60239 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab0IPW0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:26:39 -0400
Date: Thu, 16 Sep 2010 15:26:37 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Joel Becker <joel.becker@oracle.com>
Subject: Re: [PATCH 12/12] BKL: Remove BKL from OCFS2
Message-ID: <20100916222637.GB32307@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de> <1284659185-8942-13-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284659185-8942-13-git-send-email-arnd@arndb.de>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 07:46:25PM +0200, Arnd Bergmann wrote:
> The BKL in ocfs2/dlmfs is used in put_super, fill_super and remount_fs
> that are all three protected by the superblocks s_umount rw_semaphore.

Those look good, thanks.


> The use in ocfs2_control_open is evidently unrelated and the function
> is protected by ocfs2_control_lock.

<snip>

> @@ -612,12 +611,10 @@ static int ocfs2_control_open(struct inode *inode, struct file *file)
>  		return -ENOMEM;
>  	p->op_this_node = -1;
>  
> -	lock_kernel();
>  	mutex_lock(&ocfs2_control_lock);
>  	file->private_data = p;
>  	list_add(&p->op_list, &ocfs2_control_private_list);
>  	mutex_unlock(&ocfs2_control_lock);
> -	unlock_kernel();
>  
>  	return 0;
>  }

My guess is that this one is good to go too. Joel?
	--Mark

--
Mark Fasheh
