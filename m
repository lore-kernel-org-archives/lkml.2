Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab0HYJts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:49:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42188 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab0HYJtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:49:45 -0400
Message-ID: <4C74E6D6.6040203@ru.mvista.com>
Date: Wed, 25 Aug 2010 13:48:06 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Alan Ott <alan@signal11.us>
CC: Jiri Kosina <jkosina@suse.cz>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usbhid: Set Report ID properly for Output reports
 on the Control endpoint.
References: <1282020244-25786-1-git-send-email-alan@signal11.us>
In-Reply-To: <1282020244-25786-1-git-send-email-alan@signal11.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Ott wrote:

> When I made commit 29129a98e6fc89, I didn't account for *buf not being
> the report ID anymore, as buf is incremented.

> This applies to 2.6.35 and newer.

> Signed-off-by: Alan Ott <alan@signal11.us>

[...]

> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index b729c02..ffd6899 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -828,6 +828,7 @@ static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t co
>  		}
>  	} else {
>  		int skipped_report_id = 0;
> +		int report_id = buf[0];

    Please keep the empty line after the declaration block.

>  		if (buf[0] == 0x0) {
>  			/* Don't send the Report ID */
>  			buf++;

WBR, Sergei

