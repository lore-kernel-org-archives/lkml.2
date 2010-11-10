Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab0KJQiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:38:17 -0500
Received: from xenotime.net ([72.52.115.56]:44824 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756910Ab0KJQiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:38:16 -0500
Date: Wed, 10 Nov 2010 08:38:14 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: ft1000: Fix compilation warning.
Message-Id: <20101110083814.55e222c4.rdunlap@xenotime.net>
In-Reply-To: <1289384128-19823-1-git-send-email-marek.belisko@gmail.com>
References: <1289384128-19823-1-git-send-email-marek.belisko@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010 11:15:26 +0100 Marek Belisko wrote:

> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
> ---
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)


a.  always include the warning or error message that the patch fixes

b.  (quoting from another email yesterday:)

so in your analysis of this compiler warning, was the warning correct & justified,
or was it false?  I.e., is the init to NULL needed?

If it was false, could we just silence the warning by using:

	struct ft1000_info *unitialized_var(pft1000info);

plus #include <linux/compiler.h> ?


> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
> index 99e3339..b7c4602 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
> @@ -64,7 +64,7 @@ static int ft1000_probe(struct usb_interface *interface,
>  	int i, ret = 0, size;
>  
>  	struct ft1000_device *ft1000dev;
> -	struct ft1000_info *pft1000info;
> +	struct ft1000_info *pft1000info = NULL;
>  	const struct firmware *dsp_fw;
>  
>  	ft1000dev = kmalloc(sizeof(struct ft1000_device), GFP_KERNEL);
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
