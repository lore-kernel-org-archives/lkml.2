Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab0KBE1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 00:27:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59780 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab0KBE1m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 00:27:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BL4HWbcdlc29/wxP6IYxhEGS4m0sPJ4nnpaLLQOKeKyUjTjZigfJ/Xi18Ateow2CyA
         UgK7YiWMxwXUjnhp+MR/rQ3uF3t6Bdw4aeEEvz7tOJPn9axArgUMKCCbvuWwzu2NgkpV
         ylDHwVLorVZFh1uDc9WAyG1w4OLqlZUNaJizQ=
MIME-Version: 1.0
In-Reply-To: <1288668052-32036-1-git-send-email-bgamari.foss@gmail.com>
References: <1288668052-32036-1-git-send-email-bgamari.foss@gmail.com>
Date: Tue, 2 Nov 2010 13:27:41 +0900
Message-ID: <AANLkTim0oHFehpJggt9c8PhSZpOZZA1Qz=h6rC5NjeCY@mail.gmail.com>
Subject: Re: [PATCH] Add Kconfig option for default swappiness
From: Minchan Kim <minchan.kim@gmail.com>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 2, 2010 at 12:20 PM, Ben Gamari <bgamari.foss@gmail.com> wrote:
> This will allow distributions to tune this important vm parameter in a more
> self-contained manner.
>
> Signed-off-by: Ben Gamari <bgamari.foss@gmail.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  Documentation/sysctl/vm.txt |    2 +-
>  mm/Kconfig                  |   14 ++++++++++++++
>  mm/vmscan.c                 |    2 +-
>  3 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> index 30289fa..d159d02 100644
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -643,7 +643,7 @@ This control is used to define how aggressive the kernel will swap
>  memory pages.  Higher values will increase agressiveness, lower values
>  decrease the amount of swap.
>
> -The default value is 60.
> +The default value is 60 (changed with CONFIG_DEFAULT_SWAPINESS).
>
>  ==============================================================
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index c2c8a4a..dc23737 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -61,6 +61,20 @@ config SPARSEMEM_MANUAL
>
>  endchoice
>
> +config DEFAULT_SWAPPINESS
> +       int "Default swappiness"
> +       default "60"
> +       range 0 100
> +       help
> +         This control is used to define how aggressive the kernel will swap
> +         memory pages.  Higher values will increase agressiveness, lower
> +         values decrease the amount of swap. Valid values range from 0 to 100.
> +
> +         This only sets the default value at boot. Swappiness can be set at
> +         runtime through /proc/sys/vm/swappiness.
> +
> +         If unsure, keep default value of 60.
> +
>  config DISCONTIGMEM
>        def_bool y
>        depends on (!SELECT_MEMORY_MODEL && ARCH_DISCONTIGMEM_ENABLE) || DISCONTIGMEM_MANUAL
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b8a6fdc..d9f5bba 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -133,7 +133,7 @@ struct scan_control {
>  /*
>  * From 0 .. 100.  Higher means more swappy.
>  */
> -int vm_swappiness = 60;
> +int vm_swappiness = CONFIG_DEFAULT_SWAPPINESS;
>  long vm_total_pages;   /* The total number of pages which the VM controls */
>
>  static LIST_HEAD(shrinker_list);

Apparently, it wouldn't hurt maintain the kernel. But I have a concern.
As someone think this parameter is very important and would be better
to control by kernel config rather than init script to make the
package, it would make new potential kernel configs by someone in
future.
But I can't convince my opinion myself. Because if there will be lots
of kernel config for tuning parameters, could it hurt
maintain/usability? I can't say "Yes" strongly. so I am not against
this idea strongly.
Hmm,,  Just pass the decision to others.

-- 
Kind regards,
Minchan Kim
