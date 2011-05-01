Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698Ab1EAPqy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:46:54 -0400
Received: from mail.solarflare.com ([216.237.3.220]:7930 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab1EAPqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:46:51 -0400
Subject: Re: [PATCH] ipheth.c: Enable IP header alignment
From: Ben Hutchings <bhutchings@solarflare.com>
To: "L. Alberto" =?ISO-8859-1?Q?Gim=E9nez?= <agimenez@sysvalve.es>
Cc: linux-kernel@vger.kernel.org, dgiagio@gmail.com, dborca@yahoo.com,
        davem@davemloft.net, pmcenery@gmail.com, david.hill@ubisoft.com,
        "open list:USB SUBSYSTEM" <linux-usb@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
In-Reply-To: <1304247656-21086-1-git-send-email-agimenez@sysvalve.es>
References: <1304247656-21086-1-git-send-email-agimenez@sysvalve.es>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare
Date: Sun, 01 May 2011 16:46:39 +0100
Message-ID: <1304264799.2833.82.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 01 May 2011 15:46:50.0141 (UTC) FILETIME=[FC4254D0:01CC0816]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18108.005
X-TM-AS-Result: No--17.440400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-01 at 13:00 +0200, L. Alberto Giménez wrote:
> From: David Hill <david.hill@ubisoft.com>
> 
> Since commit ea812ca1b06113597adcd8e70c0f84a413d97544, NET_IP_ALIGN changed from
> 2 to 0. Some people have reported that tethering stopped working and David Hill
> submited a patch that seems to fix the problem.
> 
> I have no more an iPhone device to test it, so it is only compile-tested.
> 
> Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
> ---
>  drivers/net/usb/ipheth.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
> index 7d42f9a..711346b 100644
> --- a/drivers/net/usb/ipheth.c
> +++ b/drivers/net/usb/ipheth.c
> @@ -54,6 +54,9 @@
>  #include <linux/usb.h>
>  #include <linux/workqueue.h>
>  
> +#undef  NET_IP_ALIGN
> +#define NET_IP_ALIGN 2
> +
>  #define USB_VENDOR_APPLE        0x05ac
>  #define USB_PRODUCT_IPHONE      0x1290
>  #define USB_PRODUCT_IPHONE_3G   0x1292

No, you can't do this.

If there is some reason to use a fixed alignment of 2 (which I find hard
to believe; this is a USB device after all) then that should be
specified as a private constant.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

