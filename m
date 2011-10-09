Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab1JIPsa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 11:48:30 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53572 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751240Ab1JIPs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 11:48:28 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1/iZO1HMd7iHG0Gw+cLivE3B4PqwkebjgLpiTz1gx
	wmY3VVHOQb7FNS
From: Marc Dietrich <marvin24@gmx.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julian Andres Klode <jak@jak-linux.org>, devel@driverdev.osuosl.org,
        Leon Romanovsky <leon@leon.nu>
Subject: Re: [PATCH] fix drivers/staging/nvec linkage error when keyboard is disabled
Date: Sun, 09 Oct 2011 17:47:38 +0200
Message-ID: <1534774.fR3YHUzZE9@fb07-iapwap2>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc8+; KDE/4.7.2; x86_64; ; )
In-Reply-To: <20112.34922.209107.730268@pilspetsen.it.uu.se>
References: <20112.34922.209107.730268@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikael,

thanks for review. The nvec driver received some overhaul in the 3.1 release cycle 
and he fruids can be viewed in linux-next tree. The nvec client drivers were 
converted to mfd children in the mean time. This solves the build error, but is not 
very flexible. We are planing to move the mfd stuct to the board file(s) in the next 
cycle.

Also the maintainers were added. If you still find problems, please send email to the 
linux driver developemnt project and cc Julian and me. You may also check our 
development tree at http://gitorious.org/ac100/marvin24s-tree.  

Thanks

Marc

Am Samstag, 8. Oktober 2011, 19:29:14 schrieb Mikael Pettersson:
> Building linux-3.1-rc9 for the Tegra ARM SoC with CONFIG_MFD_NVEC=y
> and CONFIG_KEYBOARD_NVEC=n results in the following linkage error:
> 
> drivers/built-in.o: In function `tegra_nvec_probe':
> /tmp/linux-3.1-rc9/drivers/staging/nvec/nvec.c:373: undefined reference to
> `nvec_kbd_init' make: *** [.tmp_vmlinux1] Error 1
> 
> Fixed by #ifdef:ing the call to nvec_kbd_init(), similar to the
> existing #ifdef CONFIG_SERIO_NVEC_PS2 around the nvec_ps2() call.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
> ---
> 
> --- linux-3.1-rc9/drivers/staging/nvec/nvec.c.~1~	2011-10-08 16:28:20.000000000
> +0200 +++ linux-3.1-rc9/drivers/staging/nvec/nvec.c	2011-10-08 19:09:18.000000000
> +0200 @@ -370,7 +370,9 @@ static int __devinit tegra_nvec_probe(st
>  	nvec_write_async(nvec, EC_ENABLE_EVENT_REPORTING,
>  				sizeof(EC_ENABLE_EVENT_REPORTING));
> 
> +#ifdef CONFIG_KEYBOARD_NVEC
>  	nvec_kbd_init(nvec);
> +#endif
>  #ifdef CONFIG_SERIO_NVEC_PS2
>  	nvec_ps2(nvec);
>  #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
