Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0DFJkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 05:40:36 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43855 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0DFJka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 05:40:30 -0400
Message-ID: <4BBB0167.2040903@ru.mvista.com>
Date: Tue, 06 Apr 2010 13:39:51 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Vrabel <david.vrabel@csr.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] drivers/usb/wusbcore/wusbhc.h: Remove unused dev_info
 from struct wusb_port
References: <20100304232928.2e45bdd1.akpm@linux-foundation.org> <8ec25276e62c8b9669ad8e46a6f5f9cbb0f507c3.1270493677.git.joe@perches.com>
In-Reply-To: <8ec25276e62c8b9669ad8e46a6f5f9cbb0f507c3.1270493677.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Joe Perches wrote:

> There is a macro called dev_info that prints struct device specific
> information.  Having variables with the same name can be confusing and
> prevents conversion of the macro to a function.
>
> Rename the existing dev_info variables to something else in preparation
> to converting the dev_info macro to a function.
>   

   You're not renaming the variable in this case, you're removing a field.

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/usb/wusbcore/wusbhc.h |   10 ----------
>  1 files changed, 0 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/usb/wusbcore/wusbhc.h b/drivers/usb/wusbcore/wusbhc.h
> index 759cda5..dffda29 100644
> --- a/drivers/usb/wusbcore/wusbhc.h
> +++ b/drivers/usb/wusbcore/wusbhc.h
> @@ -185,15 +185,6 @@ struct wusb_port {
>   *
>   *                 Read/Write protected by @mutex
>   *
> - * @dev_info       This array has ports_max elements. It is used to
> - *                 give the HC information about the WUSB devices (see
> - *                 'struct wusb_dev_info').
> - *
> - *	           For HWA we need to allocate it in heap; for WHCI it
> - *                 needs to be permanently mapped, so we keep it for
> - *                 both and make it easy. Call wusbhc->dev_info_set()
> - *                 to update an entry.
> - *
>   * @ports_max	   Number of simultaneous device connections (fake
>   *                 ports) this HC will take. Read-only.
>   *
> @@ -259,7 +250,6 @@ struct wusbhc {
>  	struct mutex mutex;			/* locks everything else */
>  	u16 cluster_id;				/* Wireless USB Cluster ID */
>  	struct wusb_port *port;			/* Fake port status handling */
> -	struct wusb_dev_info *dev_info;		/* for Set Device Info mgmt */
>  	u8 ports_max;
>  	unsigned active:1;			/* currently xmit'ing MMCs */
>  	struct wuie_keep_alive keep_alive_ie;	/* protected by mutex */
>   

WBR, Sergei

