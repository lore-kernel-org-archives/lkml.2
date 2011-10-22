Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1JVHRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 03:17:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37021 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab1JVHRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 03:17:16 -0400
Message-ID: <4EA26DF9.8040903@gmail.com>
Date: Sat, 22 Oct 2011 01:17:13 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, airlied@redhat.com,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [DRM] Lower the severity of the radeon lockup messages.
References: <20111021165101.GA27960@redhat.com>
In-Reply-To: <20111021165101.GA27960@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2011 10:51 AM, Dave Jones wrote:
> abrt files a lot of bug reports when users get GPU lockups, but there's not really
> enough context to do anything useful with them.  Given the lack of GPU context being
> dumped, this patch removes the stack trace, so that abrt ignores the messages.
>
> Signed-off-by: Dave Jones<davej@redhat.com>
>
> diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
> index 7fd4e3e..a488b50 100644
> --- a/drivers/gpu/drm/radeon/radeon_fence.c
> +++ b/drivers/gpu/drm/radeon/radeon_fence.c
> @@ -263,7 +263,7 @@ retry:
>   		 */
>   		if (seq == rdev->fence_drv.last_seq&&  radeon_gpu_is_lockup(rdev)) {
>   			/* good news we believe it's a lockup */
> -			WARN(1, "GPU lockup (waiting for 0x%08X last fence id 0x%08X)\n",
> +			printk(KERN_WARNING "GPU lockup (waiting for 0x%08X last fence id 0x%08X)\n",
>   			     fence->seq, seq);
>   			/* FIXME: what should we do ? marking everyone
>   			 * as signaled for now

At the risk of sounding obvious, wouldn't it be better to enhance the 
driver to dump out more useful debugging info in this case rather than 
just suppressing the ABRT report?
