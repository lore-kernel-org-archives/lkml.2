Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab1JMQc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:32:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab1JMQcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:32:24 -0400
Subject: Re: [PATCH 10/13] filesystems: add set_nlink()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        akpm@linux-foundation.org, toshi.okajima@jp.fujitsu.com,
        mszeredi@suse.cz
In-Reply-To: <1318430946-7091-11-git-send-email-miklos@szeredi.hu>
References: <1318430946-7091-1-git-send-email-miklos@szeredi.hu>
	 <1318430946-7091-11-git-send-email-miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 13 Oct 2011 17:33:19 +0100
Message-ID: <1318523599.2719.45.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2011-10-12 at 16:49 +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Replace remaining direct i_nlink updates with a new set_nlink()
> updater function.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
[snip]



> diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
> index da21eca..102cf5e 100644
> --- a/fs/gfs2/glops.c
> +++ b/fs/gfs2/glops.c
> @@ -277,7 +277,7 @@ static void gfs2_set_nlink(struct inode *inode, u32 nlink)
>  		if (nlink == 0)
>  			clear_nlink(inode);
>  		else
> -			inode->i_nlink = nlink;
> +			set_nlink(inode, nlink);
>  	}
>  }

So long as it is ok to call set_nlink() with nlink == 0, then the if
statement here can be removed and just replaced with set_nlink()

Steve.



