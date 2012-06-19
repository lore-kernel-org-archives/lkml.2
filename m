Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab2FSLND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:13:03 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49949 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2FSLNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:13:00 -0400
Message-ID: <4FE05E90.6000307@mvista.com>
Date: Tue, 19 Jun 2012 15:12:16 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michal Nazarewicz <mpn@google.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb: gadget: mass_storage: require backing file for
 non-removable LUNs
References: <cover.1340022674.git.mina86@mina86.com> <593bff689c31fefb07534e3f500d8a8c29fcdacb.1340022674.git.mina86@mina86.com>
In-Reply-To: <593bff689c31fefb07534e3f500d8a8c29fcdacb.1340022674.git.mina86@mina86.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 18-06-2012 16:37, Michal Nazarewicz wrote:

> From: Michal Nazarewicz<mina86@mina86.com>

> The fsg_file_store()

    Apparently, fsg_store_file(), judging by the patch itself.

> function does not check whether a LUN is removable or not
> allowing one to specify an empty file name for a non-removable LUN.  This
> commit adds explicit check of whether a file name is provided for
> non-removable LUNs.

> Signed-off-by: Michal Nazarewicz<mina86@mina86.com>
> ---
>   drivers/usb/gadget/storage_common.c |    3 +++
>   1 files changed, 3 insertions(+), 0 deletions(-)

> diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
> index e576678..52334d7 100644
> --- a/drivers/usb/gadget/storage_common.c
> +++ b/drivers/usb/gadget/storage_common.c
> @@ -878,6 +878,9 @@ static ssize_t fsg_store_file(struct device *dev, struct device_attribute *attr,
>   	if (count > 0 && buf[count-1] == '\n')
>   		((char *) buf)[count-1] = 0;		/* Ugh! */
>
> +	/* Must specify a valid file if LUN is not removable. */
> +	if (!curlun->removable&&  !*buf)
> +		return -EINVAL;

WBR, Sergei
