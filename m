Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1KBHl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 03:41:29 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:60554 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792Ab1KBHl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 03:41:27 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mfd: twl4030-audio: Fix audio codec breakage
Date: Wed, 02 Nov 2011 09:41:23 +0200
Message-ID: <1848643.7W84dlC6t3@barack>
User-Agent: KMail/4.7.2 (Linux/3.1.0-gentoo; KDE/4.7.2; x86_64; ; )
In-Reply-To: <1319013845-2628-1-git-send-email-jarkko.nikula@bitmer.com>
References: <1319013845-2628-1-git-send-email-jarkko.nikula@bitmer.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 October 2011 11:44:05 Jarkko Nikula wrote:
> Commit 57fe725 ("MFD: twl4030-codec -> twl4030-audio: Rename the driver")
> broke the device registration for twl4030 codec if twl6040 is not set.
> 
> Reason for breakage is that commit didn't update the changed config name for
> macro twl_has_codec().
> 
> Signed-off-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
> Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
> I don't know is this too late for 3.1 or would it be better to queue for
> stable when it's out? Anyway breakage happened in 3.1-rc cycle and
> unfortunately I noticed it only now.

Thanks Jarkko for noticing this. I have overlooked it probably because I'm 
using omap2plus_defconf for most of the time.

The breakage also present in 3.0. Can we queue this patch for stable 3.0.x, 
and 3.1.x?

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> ---
>  drivers/mfd/twl-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> index 01ecfee..b8eef46 100644
> --- a/drivers/mfd/twl-core.c
> +++ b/drivers/mfd/twl-core.c
> @@ -109,7 +109,7 @@
>  #define twl_has_watchdog()        false
>  #endif
> 
> -#if defined(CONFIG_TWL4030_CODEC) || defined(CONFIG_TWL4030_CODEC_MODULE)
> ||\ +#if defined(CONFIG_MFD_TWL4030_AUDIO) ||
> defined(CONFIG_MFD_TWL4030_AUDIO_MODULE) ||\ defined(CONFIG_TWL6040_CORE)
> || defined(CONFIG_TWL6040_CORE_MODULE) #define twl_has_codec()	true
>  #else

