Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab2FFS4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:56:12 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:32905 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2FFS4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:56:11 -0400
From: Oliver Neukum <oliver@neukum.org>
To: stefani@seibold.net
Subject: Re: [PATCH 01/11] fix wrong label in skel_open
Date: Wed, 6 Jun 2012 20:52:57 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
References: <1339000032-10313-1-git-send-email-stefani@seibold.net> <1339000032-10313-2-git-send-email-stefani@seibold.net>
In-Reply-To: <1339000032-10313-2-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206062052.57385.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. Juni 2012, 18:27:02 schrieb stefani@seibold.net:
> From: Stefani Seibold <stefani@seibold.net>

Thank you for putting the effort to even split this up.
It makes it much easier to review.
 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  drivers/usb/usb-skeleton.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
> index 0616f23..a57f1d2 100644
> --- a/drivers/usb/usb-skeleton.c
> +++ b/drivers/usb/usb-skeleton.c
> @@ -114,7 +114,7 @@ static int skel_open(struct inode *inode, struct file *file)
>  
>  	retval = usb_autopm_get_interface(interface);
>  	if (retval)
> -		goto out_err;
> +		goto exit;

Are you removing io_mutex? If not, the correct fix is a second label
to drop the lock, not changing the label.  

	Regards
		Oliver
