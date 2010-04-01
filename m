Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab0DAQwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:52:54 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:51490 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab0DAQwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:52:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=WZtVGNpVHHZTkwjAOoRS9ucrbcG0+mKch9Z+gRSHxOgbaOtD/2iTwiPXmcaoH57hWY
         9hCcLiK16cayg2dulvS/gpT6ZffqQ0kSmeiQbvrKSkSti3oro9udteM5FxLTd9X9GyTu
         4F/RiR1V9PYLSvBqInZDW/Q8eodyW5gukAfqM=
Message-ID: <4BB4CF55.8000400@gmail.com>
Date: Thu, 01 Apr 2010 18:52:37 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-5.9 Thunderbird/3.1b1
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] mxser: spin_lock() => spin_lock_irq()
References: <20100401155143.GC5265@bicker>
In-Reply-To: <20100401155143.GC5265@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 05:51 PM, Dan Carpenter wrote:
> This should be spin_lock_irq() to match the spin_unlock_irq().
> Originally it was a lock_kernel() but we switched everything to
> spin_lock_irq() last November.
>
> Signed-off-by: Dan Carpenter<error27@gmail.com>
>
> diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
> index e0c5d2a..ecb2d8b 100644
> --- a/drivers/char/mxser.c
> +++ b/drivers/char/mxser.c
> @@ -1768,7 +1768,7 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
>   		int len, lsr;
>
>   		len = mxser_chars_in_buffer(tty);
> -		spin_lock(&info->slock);
> +		spin_lock_irq(&info->slock);

Hmm, and there is one more error in the MOXA_ASPP_MON case. Interrupts 
are not disabled at all there. Could you fix that too?

Thanks.
