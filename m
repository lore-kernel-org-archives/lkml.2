Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab2I1DLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 23:11:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53793 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab2I1DLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 23:11:03 -0400
Date: Thu, 27 Sep 2012 22:10:56 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH V2 01/10] Secure boot: Add new capability
Message-ID: <20120928031056.GA5478@sergelap>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <1348152065-31353-2-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348152065-31353-2-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Matthew Garrett (mjg@redhat.com):
> Secure boot adds certain policy requirements, including that root must not
> be able to do anything that could cause the kernel to execute arbitrary code.
> The simplest way to handle this would seem to be to add a new capability
> and gate various functionality on that. We'll then strip it from the initial
> capability set if required.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> ---
>  include/linux/capability.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index d10b7ed..4345bc8 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -364,7 +364,11 @@ struct cpu_vfs_cap_data {
>  
>  #define CAP_BLOCK_SUSPEND    36
>  
> -#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
> +/* Allow things that trivially permit root to modify the running kernel */
> +
> +#define CAP_COMPROMISE_KERNEL  37
> +
> +#define CAP_LAST_CAP         CAP_COMPROMISE_KERNEL
>  
>  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
>  
> -- 
> 1.7.11.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
