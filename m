Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab2LEKOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:14:03 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:30131 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab2LEKN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:13:59 -0500
Date: Wed, 5 Dec 2012 11:13:52 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] HID: i2c-hid: remove unneeded test in
 i2c_hid_remove
Message-ID: <20121205111352.4d7e7876@endymion.delvare>
In-Reply-To: <1354634875-5182-12-git-send-email-benjamin.tissoires@gmail.com>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
	<1354634875-5182-12-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Dec 2012 16:27:52 +0100, Benjamin Tissoires wrote:
> ihid can not be null, so there are no reasons to test it.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/i2c-hid/i2c-hid.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index 4e3f80b..2b49929 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -890,9 +890,6 @@ static int __devexit i2c_hid_remove(struct i2c_client *client)
>  	struct i2c_hid *ihid = i2c_get_clientdata(client);
>  	struct hid_device *hid;
>  
> -	if (WARN_ON(!ihid))
> -		return -1;
> -
>  	hid = ihid->hid;
>  	hid_destroy_device(hid);
>  

This leaves <linux/bug.h> included for no good reason. Please remove it
too.

-- 
Jean Delvare
