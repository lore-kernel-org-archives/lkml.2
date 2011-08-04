Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab1HDUsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 16:48:11 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34179 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab1HDUsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 16:48:05 -0400
Date: Thu, 4 Aug 2011 22:48:00 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Bojan Prtvar <prtvar.b@gmail.com>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: kfree() NULL pointer cleanup
In-Reply-To: <1312490574-14804-1-git-send-email-prtvar.b@gmail.com>
Message-ID: <Pine.LNX.4.64.1108042247000.1424@ask.diku.dk>
References: <1312490574-14804-1-git-send-email-prtvar.b@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Aug 2011, Bojan Prtvar wrote:

> Checking for NULL pointers before kfree() is redundant.

I would find it even nicer to just add a new lavel to skip over the kfree 
in the case where pm is NULL.  It is statically apparent in the source 
code.

julia

> Signed-off-by: Bojan Prtvar <prtvar.b@gmail.com>
> ---
>  drivers/hid/hid-prodikeys.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
> index 158b389..62f95d4 100644
> --- a/drivers/hid/hid-prodikeys.c
> +++ b/drivers/hid/hid-prodikeys.c
> @@ -849,9 +849,7 @@ static int pk_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  err_stop:
>  	hid_hw_stop(hdev);
>  err_free:
> -	if (pm != NULL)
> -		kfree(pm);
> -
> +	kfree(pm);
>  	kfree(pk);
>  	return ret;
>  }
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
