Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab0KCJP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 05:15:58 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:56198 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753617Ab0KCJP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 05:15:56 -0400
Message-ID: <4CD12833.8060204@eukrea.com>
Date: Wed, 03 Nov 2010 10:15:31 +0100
From: =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dinh.Nguyen@freescale.com
CC: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        daniel@caiaq.de, u.kleine-koenig@pengutronix.de,
        xiao-lizhang@freescale.com, valentin.longchamp@epfl.ch
Subject: Re: [PATCH 2/2] ARM: imx: Add mx53 support to common msl functions.
References: <1288736227-800-1-git-send-email-Dinh.Nguyen@freescale.com> <1288736227-800-2-git-send-email-Dinh.Nguyen@freescale.com>
In-Reply-To: <1288736227-800-2-git-send-email-Dinh.Nguyen@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 2896940461823274367
X-Ovh-Remote: 82.240.38.71 (pac33-2-82-240-38-71.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

Le 02/11/2010 23:17, Dinh.Nguyen@freescale.com a écrit :
> From: Dinh Nguyen<Dinh.Nguyen@freescale.com>
>
> Add mx53 support to cpu.c and mm.c.
>
> Signed-off by: Dinh Nguyen<Dinh.Nguyen@freescale.com>
>   static void query_silicon_parameter(void)
>   {
> -	void __iomem *rom = ioremap(MX51_IROM_BASE_ADDR, MX51_IROM_SIZE);
> +	void __iomem *rom;
>   	u32 rev;
>
> +	if (cpu_is_mx51())
> +		rom = ioremap(MX51_IROM_BASE_ADDR, MX51_IROM_SIZE);
> +	else if (cpu_is_mx53())
> +		rom = ioremap(MX53_IROM_BASE_ADDR, MX53_IROM_SIZE);
> +
isn't the correct way to get the silicon revision to read the "Product 
Revision register" and "Silicon Revision register" of the IIM and not from the 
internal ROM ? (page 41-11 of the i.MX51 reference manual).

Eric
