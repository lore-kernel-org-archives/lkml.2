Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab2LEK2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:28:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab2LEK2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:28:18 -0500
Date: Wed, 5 Dec 2012 11:28:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] HID: i2c-hid: i2c_hid_get_report may fail
In-Reply-To: <1354634875-5182-10-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1212051128100.17055@pobox.suse.cz>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com> <1354634875-5182-10-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2012, Benjamin Tissoires wrote:

> If i2c_hid_get_report fails, exit i2c_hid_init_report.
> The printk log is already called by i2c_hid_get_report, so no need
> to add some more printks.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/i2c-hid/i2c-hid.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index da04948..dcacfc4 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -400,9 +400,10 @@ static void i2c_hid_init_report(struct hid_report *report, u8 *buffer,
>  	unsigned int size, ret_size;
>  
>  	size = i2c_hid_get_report_length(report);
> -	i2c_hid_get_report(client,
> +	if (i2c_hid_get_report(client,
>  			report->type == HID_FEATURE_REPORT ? 0x03 : 0x01,
> -			report->id, buffer, size);
> +			report->id, buffer, size))
> +		return;
>  
>  	i2c_hid_dbg(ihid, "report (len=%d): %*ph\n", size, size, ihid->inbuf);

Applied.

-- 
Jiri Kosina
SUSE Labs
