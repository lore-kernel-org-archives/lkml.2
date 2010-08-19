Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab0HSVq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:46:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059Ab0HSVqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:46:24 -0400
Date: Thu, 19 Aug 2010 14:46:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Wileczka <mikewileczka@yahoo.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] USB: ftdi_sio: fix endianess of max packet size
Message-Id: <20100819144620.e078fbbe.akpm@linux-foundation.org>
In-Reply-To: <281434.37339.qm@web65616.mail.ac4.yahoo.com>
References: <281434.37339.qm@web65616.mail.ac4.yahoo.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010 07:14:37 -0700 (PDT)
Michael Wileczka <mikewileczka@yahoo.com> wrote:

> From: Michael Wileczka <mikewileczka@yahoo.com>
> 
> The USB max packet size (always little-endian) was not being byte swapped on big-endian systems.
> Created with 2.6.32.16
> Applicable since [USB: ftdi_sio: fix hi-speed device packet size calculation] approx 2.6.31
> 
> Signed-off-by: Michael Wileczka <mikewileczka@yahoo.com>
> ---
> --- a/drivers/usb/serial/ftdi_sio.c
> +++ b/drivers/usb/serial/ftdi_sio.c
> @@ -1397,7 +1397,7 @@ static void ftdi_set_max_packet_size(str
>  	}
>  
>  	/* set max packet size based on descriptor */
> -	priv->max_packet_size = ep_desc->wMaxPacketSize;
> +	priv->max_packet_size = le16_to_cpu(ep_desc->wMaxPacketSize);
>  
>  	dev_info(&udev->dev, "Setting MaxPacketSize %d\n", priv->max_packet_size);
>  }

So I guess nobody noticed this because the driver deosn't get used on
big-endian machines a lot?

What are the user-visible effects of this bug?
