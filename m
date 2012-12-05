Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2LEK1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:27:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab2LEK1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:27:15 -0500
Date: Wed, 5 Dec 2012 11:27:12 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/14] HID: i2c-hid: also call i2c_hid_free_buffers in
 i2c_hid_remove
In-Reply-To: <1354634875-5182-14-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1212051127060.17055@pobox.suse.cz>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com> <1354634875-5182-14-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2012, Benjamin Tissoires wrote:

> In the case where the hid driver in charge of handling the hid part
> of the device (hid-generic for instance) fails at probe, neither
> i2c_hid_start nor i2c_hid_stop are called.
> Thus, the buffers allocated in i2c_hid_probe are never freed.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/i2c-hid/i2c-hid.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index bea4b13..62988f1 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -891,6 +891,9 @@ static int __devexit i2c_hid_remove(struct i2c_client *client)
>  
>  	free_irq(client->irq, ihid);
>  
> +	if (ihid->bufsize)
> +		i2c_hid_free_buffers(ihid);
> +
>  	kfree(ihid);

Applied.

-- 
Jiri Kosina
SUSE Labs
