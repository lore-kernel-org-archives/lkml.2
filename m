Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab1GTJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 05:56:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab1GTJ4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 05:56:23 -0400
Date: Wed, 20 Jul 2011 11:56:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ignaz Forster <ignaz.forster@gmx.de>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: emsff: properly handle emsff_init failure
In-Reply-To: <1311063244.7304.1.camel@phoenix>
Message-ID: <alpine.LNX.2.00.1107201156130.7300@pobox.suse.cz>
References: <1311063244.7304.1.camel@phoenix>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jul 2011, Axel Lin wrote:

> emsff_init() may fail, let's properly handle the failure.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/hid/hid-emsff.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-emsff.c b/drivers/hid/hid-emsff.c
> index 81877c6..a5dc13f 100644
> --- a/drivers/hid/hid-emsff.c
> +++ b/drivers/hid/hid-emsff.c
> @@ -126,7 +126,12 @@ static int ems_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  		goto err;
>  	}
>  
> -	emsff_init(hdev);
> +	ret = emsff_init(hdev);
> +	if (ret) {
> +		dev_err(&hdev->dev, "force feedback init failed\n");
> +		hid_hw_stop(hdev);
> +		goto err;
> +	}
>  
>  	return 0;
>  err:

Good catch, applied, thanks.

-- 
Jiri Kosina
SUSE Labs
