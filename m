Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab2LCQPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:15:48 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44587 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2LCQPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:15:46 -0500
Message-ID: <50BCD030.7020908@gmail.com>
Date: Mon, 03 Dec 2012 10:15:44 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Sam Ravnborg <sam@ravnborg.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V7 2/7] ARM: dt: change .dtb build rules to build in dts
 directory
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org> <1354058956-7199-2-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1354058956-7199-2-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 05:29 PM, Stephen Warren wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> The current rules have the .dtb files build in a different directory
> from the .dts files. The only reason for this is that it was what
> PowerPC has done historically. This patch changes ARM to use the generic
> dtb rule which builds .dtb files in the same directory as the source .dts.

[snip]

> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index a17d5ab..cb217f8 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -136,4 +136,12 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
>  	wm8650-mid.dtb
>  dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb
>  
> +targets += dtbs
>  endif
> +
> +dtbs: $(addprefix $(obj)/, $(dtb-y))
> +	# *.dtb used to be generated in the directory above. Clean out the
> +	# old build results so people don't accidentally use them.
> +	rm -f $(obj)/../*.dtb

Do you intend for this to print out? Seems a little noisy to me for a
one-time problem. Are you trying to tell users the dtb files moved or
just prevent them from using the old ones? Quietly removing them would
still accomplish the latter.

Rob

> +
> +clean-files := *.dtb
> 

