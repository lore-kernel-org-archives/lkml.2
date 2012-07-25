Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab2GYBXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 21:23:17 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62253 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2GYBXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 21:23:16 -0400
Date: Tue, 24 Jul 2012 21:23:13 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: Vivek Trivedi <vtrivedi018@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: bcm: use SEEK_SET instead of 0 in vfs_llseek
Message-ID: <20120725012312.GA2961@gmail.com>
References: <1343145304-4555-1-git-send-email-vtrivedi018@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343145304-4555-1-git-send-email-vtrivedi018@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 09:25:04PM +0530, Vivek Trivedi wrote:
> They're equivalent, but SEEK_SET seems more informative...
> 
> Signed-off-by: Vivek Trivedi <vtrivedi018@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> ---
>  drivers/staging/bcm/Misc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
> index 8223a69..8fab3ec 100644
> --- a/drivers/staging/bcm/Misc.c
> +++ b/drivers/staging/bcm/Misc.c
> @@ -203,7 +203,7 @@ static int BcmFileDownload(PMINI_ADAPTER Adapter, const char *path, unsigned int
>  	}
>  	oldfs = get_fs();
>  	set_fs(get_ds());
> -	vfs_llseek(flp, 0, 0);
> +	vfs_llseek(flp, 0, SEEK_SET);

Acked-by: Kevin McKinney <klmckinney1@gmail.com>
