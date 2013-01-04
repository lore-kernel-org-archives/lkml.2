Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3ADRTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 12:19:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:39140 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab3ADRTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 12:19:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,411,1355126400"; 
   d="scan'208";a="272924571"
From: "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7u1 06/31] x86, 64bit, realmode: use init_level4_pgt to
 set trapmoline_pgt directly
Thread-Topic: [PATCH v7u1 06/31] x86, 64bit, realmode: use init_level4_pgt
 to set trapmoline_pgt directly
Thread-Index: AQHN6hVnL146f94eBke+cgM6IRM815g5awmA
Date: Fri, 4 Jan 2013 17:18:31 +0000
Message-ID: <1357319947.7763.1.camel@jsakkine-mobl1>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	 <1357260531-11115-7-git-send-email-yinghai@kernel.org>
In-Reply-To: <1357260531-11115-7-git-send-email-yinghai@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.14.29]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D4B885555F42B24EA5751B4C09C00042@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r04HJDkJ015595

On Thu, 2013-01-03 at 16:48 -0800, Yinghai Lu wrote:
> with #PF handler way to set early page table, level3_ident will go away with
> 64bit native path.
> 
> So just use entries in init_level4_pgt to set them in tramopline_pgt
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>

> ---
>  arch/x86/realmode/init.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
> index b96fe6f..384b3f4 100644
> --- a/arch/x86/realmode/init.c
> +++ b/arch/x86/realmode/init.c
> @@ -78,8 +78,8 @@ void __init setup_real_mode(void)
>  	*trampoline_cr4_features = read_cr4();
>  
>  	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
> -	trampoline_pgd[0] = __pa_symbol(level3_ident_pgt) + _KERNPG_TABLE;
> -	trampoline_pgd[511] = __pa_symbol(level3_kernel_pgt) + _KERNPG_TABLE;
> +	trampoline_pgd[0] = init_level4_pgt[pgd_index(__PAGE_OFFSET)].pgd;
> +	trampoline_pgd[511] = init_level4_pgt[511].pgd;
>  #endif
>  }
>  

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
