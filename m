Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab1CJKiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:38:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab1CJKiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:38:16 -0500
Date: Thu, 10 Mar 2011 11:38:14 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, rydberg@euromail.se, chatty@enac.fr
Subject: Re: [PATCH 1/2] hid: ntrig NO_INIT_REPORTS
In-Reply-To: <1299731632-9814-1-git-send-email-rafi@seas.upenn.edu>
Message-ID: <alpine.LNX.2.00.1103101138040.19969@pobox.suse.cz>
References: <1299731632-9814-1-git-send-email-rafi@seas.upenn.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Mar 2011, Rafi Rubin wrote:

> Probing reports does bad things with some ntrig firmwares, better to
> just leave them alone.
> 
> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
> 
> ---
> 
> This resolves an annoying delay on initialization and reduces the
> chance of the device coming up in an odd state or crashing.

Applied.

> ---
>  drivers/hid/hid-ntrig.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
> index b1e9cca..850ba14 100644
> --- a/drivers/hid/hid-ntrig.c
> +++ b/drivers/hid/hid-ntrig.c
> @@ -837,7 +837,8 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  	struct hid_report *report;
>  
>  	if (id->driver_data)
> -		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
> +		hdev->quirks |= HID_QUIRK_MULTI_INPUT
> +				| HID_QUIRK_NO_INIT_REPORTS;
>  
>  	nd = kmalloc(sizeof(struct ntrig_data), GFP_KERNEL);
>  	if (!nd) {
> -- 
> 1.7.4.1
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
