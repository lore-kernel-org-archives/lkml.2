Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab2IGTYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:24:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64180 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab2IGTYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:24:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 08/31] arm64: CPU support
Date: Fri, 7 Sep 2012 19:24:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-9-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-9-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071924.38430.arnd@arndb.de>
X-Provags-ID: V02:K0:SAxb+wC5IU30yXSkYHnYVU00HctQQ5R86fjxknJ2d74
 c28FslPbg2qZcXf6bbgkKDlLqf0+lSuIbxSXggKHX5h4hCCXMW
 Ab/XnzzZS3b5uFXx9vUl/TjfTrM1/KftN5qvLbWzgVafsC+EUS
 5C6OLZ/sY69XJAfBgld0tqJJyr7MOLb93NGsc1hgVp59RE0Gd9
 0Lo+3BvOvq4zzJiY2m1seiBKIL//YqWOcUv9lyB7mpYUD78r77
 aYuV6P6ZP3bfCOSkO8Jh8Y2wrJQJWXb2GtF4Bm8Lv080AhRUal
 ovjr3IoV6fApGm11wGLAM/r9RvbLWEeQ1wIOFIJ/SUdqAqLuVC
 1v7jFh3Cj8l0S8loAAEg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> +
> +#include <asm/cputable.h>
> +
> +extern unsigned long __cpu_setup(void);
> +
> +struct cpu_info __initdata cpu_table[] = {
> +	{
> +		.cpu_id_val	= 0x000f0000,
> +		.cpu_id_mask	= 0x000f0000,
> +		.cpu_name	= "AArch64 Processor",
> +		.cpu_setup	= __cpu_setup,
> +	},
> +	{ /* Empty */ },
> +};

> +#define MAIR(attr, mt)	((attr) << ((mt) * 8))
> +
> +ENTRY(cpu_proc_init)
> +	ret
> +ENDPROC(cpu_proc_init)
> +
> +ENTRY(cpu_proc_fin)
> +	ret
> +ENDPROC(cpu_proc_fin)


These seem to be leftovers from multi-cpu support that can be removed.

	Arnd
