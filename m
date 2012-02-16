Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab2BPUDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:03:17 -0500
Received: from 15.mo5.mail-out.ovh.net ([178.33.107.29]:49480 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755217Ab2BPUDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:03:13 -0500
X-Greylist: delayed 16799 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Feb 2012 15:03:13 EST
Date: Thu, 16 Feb 2012 16:09:33 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: linux@arm.linux.org.uk, nicolas.pitre@linaro.org, tony@atomide.com,
        s.hauer@pengutronix.de, magnus.damm@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 1/2] ARM: remove memmove from boot/compressed/string.c
Message-ID: <20120216150933.GD19779@game.jcrosoft.org>
References: <1329404057-26346-1-git-send-email-michael.opdenacker@free-electrons.com>
 <1329404057-26346-2-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329404057-26346-2-git-send-email-michael.opdenacker@free-electrons.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 2144557847889947465
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeguddrvdduucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeguddrvdduucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:54 Thu 16 Feb     , Michael Opdenacker wrote:
> This patch removes the memmove function from boot/compressed/string.c
> - This definition conflicts with the one in lib/decompress_unxz.c
>   This change is required to support xz compression on ARM.
> - memmove is not used in any of the other decompressors
>   in lib/decompress_*.c
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  arch/arm/boot/compressed/string.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/compressed/string.c b/arch/arm/boot/compressed/string.c
> index 36e53ef..369443a 100644
> --- a/arch/arm/boot/compressed/string.c
> +++ b/arch/arm/boot/compressed/string.c
> @@ -40,6 +40,7 @@ void *memcpy(void *__dest, __const void *__src, size_t __n)
>  	return __dest;
>  }
>  
> +/*
>  void *memmove(void *__dest, __const void *__src, size_t count)
>  {
>  	unsigned char *d = __dest;
> @@ -55,6 +56,7 @@ void *memmove(void *__dest, __const void *__src, size_t count)
>  		d[count] = s[count];
>  	return __dest;
>  }
> +*/
so why not drop it cleanly

Best Regards,
J.
