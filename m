Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab0LWV6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 16:58:45 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63109 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab0LWV6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 16:58:44 -0500
Date: Thu, 23 Dec 2010 14:58:41 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        linux-arch@vger.kernel.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 2/4] x86/of: Add building device tree blob(s) into
 image.
Message-ID: <20101223215841.GH20384@angua.secretlab.ca>
References: <1293047849-26078-1-git-send-email-dirk.brandewie@gmail.com>
 <1293047849-26078-3-git-send-email-dirk.brandewie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293047849-26078-3-git-send-email-dirk.brandewie@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 11:57:27AM -0800, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> This patch adds linking device tree blob into vmlinux. DTB's are
> added by adding the blob object name to list of objects to be linked
> into the image.
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  arch/x86/platform/ce4100/Makefile |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/platform/ce4100/Makefile b/arch/x86/platform/ce4100/Makefile
> index 91fc929..e5f3b7b 100644
> --- a/arch/x86/platform/ce4100/Makefile
> +++ b/arch/x86/platform/ce4100/Makefile
> @@ -1 +1,11 @@
>  obj-$(CONFIG_X86_INTEL_CE)	+= ce4100.o
> +clean-files := *dtb.S
> +
> +ifdef CONFIG_X86_OF
> +###
> +# device tree blob
> +obj-$(CONFIG_X86_INTEL_CE) += ce4100.dtb.o
> +
> +$(obj)/%.dtb: $(src)/%.dts
> +	$(call cmd,dtc)
> +endif

Skipped for now; will pick up after ce4100 is in mainline since this
is a pretty low-risk change.

g.

> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
