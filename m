Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab0I0I7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:59:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44556 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab0I0I7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:59:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WbciT+E76k7N5ukZU7ASAiwkf6eZpn0NgDHPdcBT5DT8UbZMM22Yt1gmAGiNceH0AS
         v05X4PTyez2z5nNWploENE2fuzaSZjVv3x8Utem/ZGGKQHSeZ7NsWBn6Jj2JXn6nQvCa
         5pvZ/YdzoWqO/X8j20CNh9I2j+FwVbcP4/OuI=
Subject: Re: [PATCH] ubifs: avoid kernel error if ubifs superblock read
 fails
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Steffen Sledz <sledz@dresearch.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1285322081-17144-1-git-send-email-sledz@dresearch.de>
References: <1285322081-17144-1-git-send-email-sledz@dresearch.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 11:57:17 +0300
Message-ID: <1285577837.16181.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-24 at 11:54 +0200, Steffen Sledz wrote:
> * .get_sb is called on mounts with automatic fs detection too, so this
>   function should not print an error if it cannot read the superblock
>   (new behaviour conforms the other fs types)
> 
> Signed-off-by: Steffen Sledz <sledz@dresearch.de>
> ---
>  fs/ubifs/super.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index cd5900b..e62bb75 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
> @@ -2049,8 +2049,6 @@ static int ubifs_get_sb(struct file_system_type *fs_type, int flags,
>  	 */
>  	ubi = open_ubi(name, UBI_READONLY);
>  	if (IS_ERR(ubi)) {
> -		ubifs_err("cannot open \"%s\", error %d",
> -			  name, (int)PTR_ERR(ubi));
>  		return PTR_ERR(ubi);
>  	}
>  	ubi_get_volume_info(ubi, &vi);

Hi, could you please instead turn this message into dbg_err() - in this
case we'll have the message only when debugging is enabled.

Also, please CC:

Artem Bityutskiy <dedekind1@gmail.com>
linux-mtd@lists.infradead.org

Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

