Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab1LHJAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:00:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45555 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1LHJAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:00:33 -0500
Message-ID: <1323334812.3904.8.camel@lappy>
Subject: Re: [PATCH -tip] kvm_tools: fix build fail
From: Sasha Levin <levinsasha928@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 08 Dec 2011 11:00:12 +0200
In-Reply-To: <4EE07AE6.10804@cn.fujitsu.com>
References: <4EE07AE6.10804@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-8859-7"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

This was fixed in the KVM tools tree 2 days ago, but not pulled into
-tip yet.

Thanks!

On Thu, 2011-12-08 at 16:52 +0800, Lai Jiangshan wrote:
> Commit e5fd47bfab2df0c2184cc0bf4245d8e1bb7724fb in -tip tree adds a
> "bool set_pm_idle_to_default(void);" to system.h which causes kvm_tool build fail:
> 
> In file included from include/kvm/barrier.h:13:0,
>                  from virtio/core.c:5:
> ../../arch/x86/include/asm/system.h:404:6: error: expected ¡=¢, ¡,¢, ¡;¢, ¡asm¢ or ¡__attribute__¢ before ¡set_pm_idle_to_default¢
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/tools/kvm/include/kvm/barrier.h b/tools/kvm/include/kvm/barrier.h
> index c11a239..480276f 100644
> --- a/tools/kvm/include/kvm/barrier.h
> +++ b/tools/kvm/include/kvm/barrier.h
> @@ -7,6 +7,7 @@
>   * Provide the dependencies here - we can drop these wrappers once
>   * the header is fixed upstream:
>   */
> +#include <stdbool.h>
>  #include <linux/stringify.h>
>  #include <linux/bitops.h>
>  #include <asm/alternative.h>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 

Sasha.

