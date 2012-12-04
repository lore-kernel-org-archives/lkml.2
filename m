Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2LDVuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 16:50:00 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:11278 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab2LDVt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 16:49:57 -0500
Date: Tue, 4 Dec 2012 22:49:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/14] HID: i2c-hid: fix i2c_hid_dbg macro
Message-ID: <20121204224950.6ebd7346@endymion.delvare>
In-Reply-To: <1354634875-5182-6-git-send-email-benjamin.tissoires@gmail.com>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
	<1354634875-5182-6-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Dec 2012 16:27:46 +0100, Benjamin Tissoires wrote:
> This avoids the problematic case:
> 
> if (condition)
> 	i2c_hid_dbg(ihid, "Blah blah %d\n", i);
> else
> 	do_something_very_important();
> 
> Which looks correct, however with the previous macro definition,
> this expands to the unexpected:
> 
> if (condition) {
> 	if (debug)	\
> 		dev_printk(KERN_DEBUG, &ihid->client->dev,
> 				"Blah blah %d\n", i);
> 	else
> 		do_something_very_important();
> }
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/i2c-hid/i2c-hid.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index 9ee6555..54950be 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -50,9 +50,11 @@ static bool debug;
>  module_param(debug, bool, 0444);
>  MODULE_PARM_DESC(debug, "print a lot of debug information");
>  
> -#define i2c_hid_dbg(ihid, fmt, arg...)	\
> -	if (debug)			\
> -		dev_printk(KERN_DEBUG, &(ihid)->client->dev, fmt, ##arg)
> +#define i2c_hid_dbg(ihid, fmt, arg...)					  \
> +do {									  \
> +	if (debug)							  \
> +		dev_printk(KERN_DEBUG, &(ihid)->client->dev, fmt, ##arg); \
> +} while (0)
>  
>  struct i2c_hid_desc {
>  	__le16 wHIDDescLength;

Reviewed-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
