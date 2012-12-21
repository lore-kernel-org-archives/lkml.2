Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab2LUH7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 02:59:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab2LUH7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 02:59:20 -0500
Date: Fri, 21 Dec 2012 13:29:09 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: correct error message on failure of
 debugfs_create_dir
Message-ID: <20121221075909.GA15739@amit.redhat.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
 <1356030701-16284-13-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356030701-16284-13-git-send-email-sasha.levin@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) 20 Dec 2012 [14:11:21], Sasha Levin wrote:
> debugfs_create_dir() returns NULL if it fails, there's little point in
> calling PTR_ERR on it.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  drivers/char/virtio_console.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index c594cb1..490b70e 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -2212,10 +2212,9 @@ static int __init init(void)
>  	}
>  
>  	pdrvdata.debugfs_dir = debugfs_create_dir("virtio-ports", NULL);
> -	if (!pdrvdata.debugfs_dir) {
> -		pr_warning("Error %ld creating debugfs dir for virtio-ports\n",
> -			   PTR_ERR(pdrvdata.debugfs_dir));
> -	}
> +	if (!pdrvdata.debugfs_dir)
> +		pr_warn("Error creating debugfs dir for virtio-ports\n");

debugfs_create_dir() does return an error value if debugfs is not
enabled.

This check for !pdrvdata.debugfs_dir should infact use
IS_ERR_OR_NULL().  Care to submit a patch for that?

		Amit
