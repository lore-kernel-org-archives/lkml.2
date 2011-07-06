Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1GFWqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 18:46:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752959Ab1GFWqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 18:46:03 -0400
Date: Wed, 6 Jul 2011 15:45:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix loopback devices to emit uevent on auto release
Message-Id: <20110706154558.1a87054e.akpm@linux-foundation.org>
In-Reply-To: <4E0912A9.7030403@cfl.rr.com>
References: <4E0912A9.7030403@cfl.rr.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011 19:30:49 -0400
Phillip Susi <psusi@cfl.rr.com> wrote:

> commit 4d5498b2b400ee4781b25fa9fa219eadf11c1ef5
> Author: Phillip Susi <psusi@cfl.rr.com>
> Date:   Mon Jun 27 18:55:00 2011 -0400
> 
>     Fixed loopback device to emit uevent on auto release
>     
>     The loopback driver failed to emit the change uevent
>     when auto releasing the device.  Fixed lo_release()
>     to pass the bdev to loop_clr_fd() so it can emit
>     the event.
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index dbf31ec..ba915ce 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1522,7 +1522,7 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
>  		 * In autoclear mode, stop the loop thread
>  		 * and remove configuration after last close.
>  		 */
> -		err = loop_clr_fd(lo, NULL);
> +		err = loop_clr_fd(lo, lo->lo_device);
>  		if (!err)
>  			goto out_unlocked;
>  	} else {

The patch is missing your Signed-off-by:.  Please review
Documentation/SubmittingPatches section 12 to see what this means. 
Then, if agreeable, please send us that Signed-off-by:, thanks.

