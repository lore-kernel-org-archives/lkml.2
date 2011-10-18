Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab1JRQxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:53:45 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47232 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab1JRQxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:53:43 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: Re: [PATCHv3 6/7] input/cma3000_d0x: Unwind reverse order of init
Date: Tue, 18 Oct 2011 09:53:33 -0700
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9+; KDE/4.6.5; x86_64; ; )
Cc: sameo@linux.intel.com, peter.ujfalusi@ti.com, aghayal@codeaurora.org,
        david@hardeman.nu, Shubhrajyoti@ti.com, saaguirre@ti.com,
        jic23@cam.ac.uk, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1318952886-835-1-git-send-email-ricardo.ribalda@gmail.com> <1318952886-835-7-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1318952886-835-7-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110180953.34156.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 18, 2011 08:48:05 AM Ricardo Ribalda Delgado wrote:
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/input/misc/cma3000_d0x.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/misc/cma3000_d0x.c
> b/drivers/input/misc/cma3000_d0x.c index bbda34c..96a46d4 100644
> --- a/drivers/input/misc/cma3000_d0x.c
> +++ b/drivers/input/misc/cma3000_d0x.c
> @@ -459,8 +459,8 @@ EXPORT_SYMBOL(cma3000_init);
> 
>  void cma3000_exit(struct cma3000_accl_data *data)
>  {
> -	free_irq(data->irq, data);
>  	input_unregister_device(data->input_dev);
> +	free_irq(data->irq, data);
>  	kfree(data);
>  }
>  EXPORT_SYMBOL(cma3000_exit);

No, the original is much safer. Unless you 110% sure you won't get
an interrupt between unregistering device (which is most likely
will free the associated data structure) and freeing irq it is
better to leave it as is.

Thanks.

-- 
Dmitry
