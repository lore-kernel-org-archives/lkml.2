Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab2LCI2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 03:28:41 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44843 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2LCI2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 03:28:39 -0500
Message-ID: <50BC62BD.2060602@zankel.net>
Date: Mon, 03 Dec 2012 00:28:45 -0800
From: czankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Arnd Bergmann <arnd@arndb.de>, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Max Filippov <jcmvbkbc@gmail.com>, linux-c6x-dev@linux-c6x.org,
        linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 5/5] xtensa: Use generic asm/mmu.h for nommu
References: <1351765467-29244-1-git-send-email-lars@metafoo.de> <1351765467-29244-5-git-send-email-lars@metafoo.de>
In-Reply-To: <1351765467-29244-5-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Lars, I have added it to the Xtensa for_next tree.

-Chris

On 11/1/12 3:24 AM, Lars-Peter Clausen wrote:
> The nommu portion of mmu.h of the extensa platform is basically the same as the
> asm-generic mmu.h. So use it instead.
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>
> ---
> Note, due to lack of toolchain, etc this patch is completely untested.
> ---
>   arch/xtensa/include/asm/mmu.h   |    2 +-
>   arch/xtensa/include/asm/nommu.h |    3 ---
>   2 files changed, 1 insertions(+), 4 deletions(-)
>   delete mode 100644 arch/xtensa/include/asm/nommu.h
>
> diff --git a/arch/xtensa/include/asm/mmu.h b/arch/xtensa/include/asm/mmu.h
> index 04890d6..8554b2c 100644
> --- a/arch/xtensa/include/asm/mmu.h
> +++ b/arch/xtensa/include/asm/mmu.h
> @@ -12,7 +12,7 @@
>   #define _XTENSA_MMU_H
>   
>   #ifndef CONFIG_MMU
> -#include <asm/nommu.h>
> +#include <asm-generic/mmu.h>
>   #else
>   
>   /* Default "unsigned long" context */
> diff --git a/arch/xtensa/include/asm/nommu.h b/arch/xtensa/include/asm/nommu.h
> deleted file mode 100644
> index dce2c43..0000000
> --- a/arch/xtensa/include/asm/nommu.h
> +++ /dev/null
> @@ -1,3 +0,0 @@
> -typedef struct {
> -	unsigned long end_brk;
> -} mm_context_t;

