Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab2DIIoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:44:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055Ab2DIIoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:44:16 -0400
Date: Mon, 9 Apr 2012 11:44:28 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: zwu.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org, stefanha@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH] vhost_test: fix compile breakage
Message-ID: <20120409084427.GB28362@redhat.com>
References: <1333960256-7491-1-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333960256-7491-1-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 04:30:56PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> The arguments of vhost_dev_cleanup has been changed. So test.c need to be changed accordingly.
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Applied, thanks.

> ---
>  drivers/vhost/test.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index fc9a1d7..3de00d9 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -155,7 +155,7 @@ static int vhost_test_release(struct inode *inode, struct file *f)
>  
>  	vhost_test_stop(n, &private);
>  	vhost_test_flush(n);
> -	vhost_dev_cleanup(&n->dev);
> +	vhost_dev_cleanup(&n->dev, false);
>  	/* We do an extra flush before freeing memory,
>  	 * since jobs can re-queue themselves. */
>  	vhost_test_flush(n);
> -- 
> 1.7.6
