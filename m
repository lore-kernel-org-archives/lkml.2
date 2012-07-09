Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab2GIO1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:27:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41277 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab2GIO1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:27:22 -0400
Date: Mon, 9 Jul 2012 16:27:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Keng-Yu Lin <kengyu@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: hid-input: Add suport for the brightness control
 keys on HP keyboards
In-Reply-To: <1341569171-12990-1-git-send-email-kengyu@canonical.com>
Message-ID: <alpine.LNX.2.00.1207091626090.19366@pobox.suse.cz>
References: <1341569171-12990-1-git-send-email-kengyu@canonical.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2012, Keng-Yu Lin wrote:

> The keys are found on the keyboards bundled with HP All-In-One machines
> with USB VID/PID of 04ca:004d and 04f2:1061.
> 
> Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
> ---
>  drivers/hid/hid-input.c |    9 +++++++++
>  include/linux/hid.h     |    1 +
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index f333139..ecb8e48 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -648,6 +648,15 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
>  		}
>  		break;
>  
> +	case HID_UP_HPVENDOR2:
> +		set_bit(EV_REP, input->evbit);
> +		switch (usage->hid & HID_USAGE) {
> +		case 0x003: map_key_clear(KEY_BRIGHTNESSDOWN);	break;
> +		case 0x004: map_key_clear(KEY_BRIGHTNESSUP);	break;
> +		default:    goto ignore;
> +		}
> +		break;
> +
>  	case HID_UP_MSVENDOR:
>  		goto ignore;
>  
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index c235e4e..4365959 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -198,6 +198,7 @@ struct hid_item {
>  #define HID_UP_DIGITIZER	0x000d0000
>  #define HID_UP_PID		0x000f0000
>  #define HID_UP_HPVENDOR         0xff7f0000
> +#define HID_UP_HPVENDOR2        0xff010000

Let's hope these vendor-specific usage pages don't start out-of-control 
spreading.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
