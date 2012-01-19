Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2ASXq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 18:46:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57353 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2ASXq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 18:46:58 -0500
MIME-Version: 1.0
In-Reply-To: <1326991820-31393-1-git-send-email-rabin@rab.in>
References: <20120116025331.GA16516@localhost>
	<1326991820-31393-1-git-send-email-rabin@rab.in>
Date: Fri, 20 Jan 2012 08:46:56 +0900
Message-ID: <CAKYAXd8poi6Rs7wyvZHre6qx-_i7eq0SBQAJNKNTYTLC5RQKjA@mail.gmail.com>
Subject: Re: [PATCHv2] backing-dev: fix wakeup timer races with bdi_unregister()
From: Namjae Jeon <linkinjeon@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: fengguang.wu@intel.com, axboe@kernel.dk, linux-kernel@vger.kernel.org,
        chanho0207@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>                bdi_debug_unregister(bdi);
> -               device_unregister(bdi->dev);
> +
> +               spin_lock_bh(&bdi->wb_lock);
>                bdi->dev = NULL;
> +               spin_unlock_bh(&bdi->wb_lock);
Hi.
Would you explain me why you add spinlock in here ?
Thanks.
> +
> +               device_unregister(dev);
>        }
>  }
>  EXPORT_SYMBOL(bdi_unregister);
> --
> 1.7.7.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
