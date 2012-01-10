Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab2AJAZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 19:25:23 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:44351 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933521Ab2AJAZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 19:25:21 -0500
Message-ID: <4F0B8571.1040106@boundarydevices.com>
Date: Mon, 09 Jan 2012 17:25:21 -0700
From: Troy Kisky <troy.kisky@boundarydevices.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] rtl8192cu: Fix WARNING on suspend/resume
References: <4f0b6e4d.P81fZnkPWac6eQEc%Larry.Finger@lwfinger.net>
In-Reply-To: <4f0b6e4d.P81fZnkPWac6eQEc%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {1412:box284.bluehost.com:boundar4:boundarydevices.com} {sentby:smtp auth 70.96.116.236 authed with troy.kisky@boundarydevices.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/2012 3:46 PM, Larry Finger wrote:
>
> +#ifdef CONFIG_PM_SLEEP
> +static int rtl8192cu_usb_suspend(struct usb_interface *pusb_intf,
> +				 pm_message_t message)
> +{
> +	/* Increase usage_count to Save loaded fw across suspend/resume */
> +	atomic_inc(&usage_count);
> +	return 0;
> +}
> +
>
If firmware is not actively loaded on a 0 to 1 transition of 
usage_count, what good is this
atomic_inc doing?

I admit that my understanding is probably at fault, but it looks odd.


I took off list because this message is probably just noise.

Troy

