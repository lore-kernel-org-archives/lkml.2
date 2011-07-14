Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1GNJne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 05:43:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab1GNJnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 05:43:32 -0400
Date: Thu, 14 Jul 2011 11:43:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>,
        Sergei Kolzun <x0r@dv-life.ru>, linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: ACRUX - add missing hid_hw_stop() in ax_probe()
 error path
In-Reply-To: <1310620071.2721.3.camel@phoenix>
Message-ID: <alpine.LNX.2.00.1107141143230.7300@pobox.suse.cz>
References: <1310620071.2721.3.camel@phoenix>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011, Axel Lin wrote:

> hid_hw_stop() must be called in ax_probe() error path if hid_hw_start()
> was successful.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/hid/hid-axff.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-axff.c b/drivers/hid/hid-axff.c
> index b455428..1215141 100644
> --- a/drivers/hid/hid-axff.c
> +++ b/drivers/hid/hid-axff.c
> @@ -154,6 +154,7 @@ static int ax_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  	error = hid_hw_open(hdev);
>  	if (error) {
>  		dev_err(&hdev->dev, "hw open failed\n");
> +		hid_hw_stop(hdev);
>  		return error;
>  	}

Good catch, applied. Thanks,

-- 
Jiri Kosina
SUSE Labs
