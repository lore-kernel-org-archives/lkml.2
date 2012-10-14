Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab2JNPv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:51:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab2JNPv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:51:56 -0400
Message-ID: <507ADEB0.2040303@redhat.com>
Date: Sun, 14 Oct 2012 17:48:00 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Peter Stuge <peter@stuge.se>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH v3] usbdevfs: Fix broken scatter-gather transfer
References: <1350123636-4801-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1350123636-4801-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/13/2012 12:20 PM, Henrik Rydberg wrote:
> The handling of large output bulk transfers is broken; the same user
> page is read over and over again. Fixed with this patch.
>
> Cc: stable@kernel.org
> Acked-by: Peter Stuge <peter@stuge.se>
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Greg,
>
> Here is the formal and third version of the patch. Version two still
> made me nervous,

And it should, as as said before I believe it would have broken large
input transfers ...

  so I moved the increment to where it is clear that
> the buffer pointer is never referenced again later in the function. I
> still kept the ACKS, hope that is alright with everyone.

Unlike the previous one, this version should work, so yes it may keep
my ACK :)

Regards,

Hans

>
> Thanks,
> Henrik
>
>   drivers/usb/core/devio.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index ebb8a9d..7f75343 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -1348,6 +1348,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
>   					ret = -EFAULT;
>   					goto error;
>   				}
> +				uurb->buffer += u;
>   			}
>   			totlen -= u;
>   		}
>
