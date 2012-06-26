Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab2FZCCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 22:02:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:4063 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862Ab2FZCCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 22:02:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="162608967"
Message-ID: <1340676217.1682.50.camel@rui.sh.intel.com>
Subject: Re: Still use ACPI backlight control if _DOS doesn't exist
From: Zhang Rui <rui.zhang@intel.com>
To: Dave Airlie <airlied@redhat.com>
Cc: len.brown@intel.com, torvalds@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        Igor Murzov <intergalactic.anonymous@gmail.com>,
        stable@vger.kernel.org
Date: Tue, 26 Jun 2012 10:03:37 +0800
In-Reply-To: <1340624336-15048-1-git-send-email-airlied@redhat.com>
References: <1340624336-15048-1-git-send-email-airlied@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dave,

How about this one, which I think is better? :)
http://marc.info/?l=linux-acpi&m=134015703925079&w=2

can you give it a try?

thanks,
rui

On 一, 2012-06-25 at 12:38 +0100, Dave Airlie wrote:
> This is a regression introduced by commit
> ea9f8856bd6d4ed45885b06a338f7362cd6c60e5
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=43168
> 
> Some platforms don't have _DOS control method, but the ACPI
> backlight still works.
> We do not want to lose the backlight control ability on these platforms.
> 
> [airlied: this is breaking nouveau really badly on 3.4 and after and there is
> no movement on sending it upstream, so please apply]
> 
> Cc: Igor Murzov <intergalactic.anonymous@gmail.com>
> Cc: stable@vger.kernel.org
> Cc: len.brown@intel.com
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/acpi/video.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> Index: rtd3/drivers/acpi/video.c
> ===================================================================
> --- rtd3.orig/drivers/acpi/video.c
> +++ rtd3/drivers/acpi/video.c
> @@ -565,8 +565,14 @@ acpi_video_bus_DOS(struct acpi_video_bus
>  	video->dos_setting = arg0.integer.value;
>  	status = acpi_evaluate_object(video->device->handle, "_DOS",
>  		&args, NULL);
> -	if (ACPI_FAILURE(status))
> -		return -EIO;
> +	if (ACPI_FAILURE(status)) {
> +		/*
> +		 * some platforms don't have _DOS, but the ACPI
> +		 * backlight control still works
> +		 */
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No _DOS\n"));
> +		return 0;
> +	}
>  
>  	return 0;
>  }


