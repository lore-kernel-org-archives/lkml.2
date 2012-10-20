Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415Ab2JTAP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 20:15:57 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:46899 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab2JTAPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 20:15:55 -0400
Subject: Re: [PATCH V2 01/10] Secure boot: Add new capability
From: joeyli <jlee@suse.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
In-Reply-To: <1348152065-31353-2-git-send-email-mjg@redhat.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <1348152065-31353-2-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Oct 2012 08:15:42 +0800
Message-ID: <1350692142.14835.46.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt, 

Sorry for bother you!

I didn't see this Matthew's patchset merged in EFI git tree. Do you have
plan to merge it? Or those patches need wait different subsystem leaders
merge.


Thanks a lot!
Joey Lee

於 四，2012-09-20 於 10:40 -0400，Matthew Garrett 提到：
> Secure boot adds certain policy requirements, including that root must not
> be able to do anything that could cause the kernel to execute arbitrary code.
> The simplest way to handle this would seem to be to add a new capability
> and gate various functionality on that. We'll then strip it from the initial
> capability set if required.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
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


