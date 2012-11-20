Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2KTQeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:34:08 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48383 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab2KTQeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:34:06 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1211201706300.4609@pobox.suse.cz>
References: <alpine.LNX.2.00.1211201706300.4609@pobox.suse.cz>
Date: Tue, 20 Nov 2012 17:34:04 +0100
Message-ID: <CAN+gG=Fy4ixGRXJSF3bXCGWTYxMiVuO7xbNAQzx_pjUoyhGbVA@mail.gmail.com>
Subject: Re: [PATCH] HID: i2c-hid: fix memory leak during probe
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 5:09 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> In case we are returning from i2c_hid_probe() through the 'err' or
> err_mem_free labels, there is noone freeing the buffers allocated by
> i2c_hid_alloc_buffers().

ouch... thanks Jiri
I hope there are not so much others like this one :)

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>

>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/hid/i2c-hid/i2c-hid.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index 11140bd..67ab5b7 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -892,6 +892,7 @@ err:
>         if (ihid->irq)
>                 free_irq(ihid->irq, ihid);
>
> +       i2c_hid_free_buffers(ihid);
>         kfree(ihid);
>         return ret;
>  }
>
> --
> Jiri Kosina
> SUSE Labs
