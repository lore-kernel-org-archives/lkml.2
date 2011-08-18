Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1HRKjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:39:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166Ab1HRKj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:39:29 -0400
Date: Thu, 18 Aug 2011 06:42:13 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kirk w <kirkpuppy@yahoo.com>
Subject: Re: Q: cifs, freeing volume_info->UNCip
Message-ID: <20110818064213.0e4d459d@corrin.poochiereds.net>
In-Reply-To: <7087.1313450537@jrobl>
References: <7087.1313450537@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Aug 2011 08:22:17 +0900
"J. R. Okajima" <hooanon05@yahoo.co.jp> wrote:

> 
> Hello,
> 
> CIFS cleanup_volume_info_contents() looks like having a memory
> corruption problem.
> When UNCip is set to "&vol->UNC[2]" in cifs_parse_mount_options(), it
> should not be kfree()-ed in cleanup_volume_info_contents().
> 
> If it is correct and the code in mainline is not fixed yet, then here is
> a patch.
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index ccc1afa..e0ea721 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2838,7 +2838,8 @@ cleanup_volume_info_contents(struct smb_vol *volume_info)
>  	kfree(volume_info->username);
>  	kzfree(volume_info->password);
>  	kfree(volume_info->UNC);
> -	kfree(volume_info->UNCip);
> +	if (volume_info->UNCip != volume_info->UNC + 2)
> +		kfree(volume_info->UNCip);
>  	kfree(volume_info->domainname);
>  	kfree(volume_info->iocharset);
>  	kfree(volume_info->prepath);
> 
> 

Also, this patch should obviously go to stable too.

-- 
Jeff Layton <jlayton@redhat.com>
