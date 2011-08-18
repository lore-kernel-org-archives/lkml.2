Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab1HRQzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:55:24 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64176 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab1HRQzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:55:23 -0400
MIME-Version: 1.0
In-Reply-To: <7087.1313450537@jrobl>
References: <7087.1313450537@jrobl>
Date: Thu, 18 Aug 2011 11:55:22 -0500
Message-ID: <CAH2r5mvA3i8E-KAuQ=+10gfzF1q8dWwB2KQiY3W1FBw_gscurQ@mail.gmail.com>
Subject: Re: Q: cifs, freeing volume_info->UNCip
From: Steve French <smfrench@gmail.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kirk w <kirkpuppy@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged

On Mon, Aug 15, 2011 at 6:22 PM, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
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
>        kfree(volume_info->username);
>        kzfree(volume_info->password);
>        kfree(volume_info->UNC);
> -       kfree(volume_info->UNCip);
> +       if (volume_info->UNCip != volume_info->UNC + 2)
> +               kfree(volume_info->UNCip);
>        kfree(volume_info->domainname);
>        kfree(volume_info->iocharset);
>        kfree(volume_info->prepath);
>
>
> J. R. Okajima
>



-- 
Thanks,

Steve
