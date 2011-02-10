Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab1BJXzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:55:12 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51169 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab1BJXzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:55:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eoSlQbRNMKRvpIdC+lIb3K54iCUx20ZmTb1SxV83ZmJ/wsKj2NMBhyJQXnoJ9dW578
         2DpJ5PrjNDgQKFV48u8iRgetp/tYNEUcGAXMW9upNxhYpOZKcSDgIhpeeqfjyqAWTF6C
         u13KDJkvLojGE0kL0xLDITZz/x/J0yf7+HrMc=
Date: Thu, 10 Feb 2011 15:54:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: tlambert@chromium.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: fixed EVIOCGRAB iterative grab/release.
Message-ID: <20110210235447.GA12313@core.coreip.homeip.net>
References: <1297381370-16388-1-git-send-email-tlambert@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297381370-16388-1-git-send-email-tlambert@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 03:42:50PM -0800, tlambert@chromium.org wrote:
> From: Terry Lambert <tlambert@chromium.org>
> 
> Fixed order of calls in evdev_ungrab to allow iterative use of
> code which grabs and releases input event devices.
> 

Sorry, could you  please be more verbose?

> Signed-off-by: Terry Lambert <tlambert@chromium.org>
> ---
>  drivers/input/evdev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index c8471a2..0bac8da 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -160,9 +160,9 @@ static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
>  	if (evdev->grab != client)
>  		return  -EINVAL;
>  
> +	input_release_device(&evdev->handle);
>  	rcu_assign_pointer(evdev->grab, NULL);
>  	synchronize_rcu();
> -	input_release_device(&evdev->handle);
>  
>  	return 0;
>  }
> -- 
> 1.7.3.1
> 

-- 
Dmitry
