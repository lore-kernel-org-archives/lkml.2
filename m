Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1JSUIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 16:08:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59580 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab1JSUIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 16:08:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=lIIJXj1Jf+dzkO1de422yepRyE+BEgM7TxTXKWLpr/Cpy03Yjzo2gKG40PGEoyvfK
	2czykhsWTBI0NNxkXYnjQ==
Date: Wed, 19 Oct 2011 13:08:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jarkko Nikula <jarkko.nikula@bitmer.com>
cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH] mfd: twl4030-audio: Fix audio codec breakage
In-Reply-To: <1319013845-2628-1-git-send-email-jarkko.nikula@bitmer.com>
Message-ID: <alpine.DEB.2.00.1110191307010.2892@chino.kir.corp.google.com>
References: <1319013845-2628-1-git-send-email-jarkko.nikula@bitmer.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011, Jarkko Nikula wrote:

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
> stable when it's out? Anyway breakage happened in 3.1-rc cycle and unfortunately
> I noticed it only now.

I think breakage happened in 3.0-rc4, actually.  For something like that, 
it's probably best to queue it for 3.2 and then add a

	Cc: stable@vger.kernel.org [3.0.x, 3.1.x]

to the changelog.  Note that the email address for stable has changed.

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
> -#if defined(CONFIG_TWL4030_CODEC) || defined(CONFIG_TWL4030_CODEC_MODULE) ||\
> +#if defined(CONFIG_MFD_TWL4030_AUDIO) || defined(CONFIG_MFD_TWL4030_AUDIO_MODULE) ||\
>  	defined(CONFIG_TWL6040_CORE) || defined(CONFIG_TWL6040_CORE_MODULE)
>  #define twl_has_codec()	true
>  #else
