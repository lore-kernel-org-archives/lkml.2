Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2KVS41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:56:27 -0500
Received: from mga14.intel.com ([143.182.124.37]:44678 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308Ab2KVS4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:56:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,299,1352102400"; 
   d="scan'208";a="221020224"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Lothar =?utf-8?Q?Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Lothar =?utf-8?Q?Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: Re: [BUGFIX PATCH] USB: chipidea: fix use after free bug
In-Reply-To: <1353575485-23941-1-git-send-email-LW@KARO-electronics.de>
References: <1353575485-23941-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Notmuch/0.12+187~ga2502b0 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 22 Nov 2012 11:29:33 +0200
Message-ID: <87vccy3s02.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lothar Waßmann <LW@KARO-electronics.de> writes:

> The pointer to a platform_device struct must not be dereferenced after
> the device has been unregistered.
>
> This bug produces a crash when unloading the ci13xxx kernel module
> compiled with CONFIG_PAGE_POISONING enabled.
>
> Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>

Good one, thanks.

Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>

Greg, this is -stable material, applicable starting from v3.6.

> ---
>  drivers/usb/chipidea/core.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index f69d029..b726c49 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -385,8 +385,9 @@ EXPORT_SYMBOL_GPL(ci13xxx_add_device);
>  
>  void ci13xxx_remove_device(struct platform_device *pdev)
>  {
> +	int id = pdev->id;
>  	platform_device_unregister(pdev);
> -	ida_simple_remove(&ci_ida, pdev->id);
> +	ida_simple_remove(&ci_ida, id);
>  }
>  EXPORT_SYMBOL_GPL(ci13xxx_remove_device);
>  
> -- 
> 1.7.2.5
