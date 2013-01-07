Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3AGPm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:42:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54319 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3AGPmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:42:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Gerald Schaefer <geraldsc@de.ibm.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic/io.h: convert readX defines to functions
Date: Mon, 07 Jan 2013 15:42:38 +0000
Message-ID: <12944963.pK1utZClTO@wuerfel>
User-Agent: KMail/4.9.2 (Linux/3.5.0-7-generic; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20130107153459.GA6898@osiris>
References: <20130107153459.GA6898@osiris>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:tWO7KSfnImWA1/uREcQxvwr8xXptL2MXBTUMKnlkRe/
 B87vLzrvG5DLEWwxG+RJqAgJCM/hMbArprSjQcBe3ULmxSbc55
 2AQrptJ464gSnTEP7oDUMrnO0QYRXVsRxF+YSMOZbevHSh/Yaj
 Ucxfz6aF0B5HTK5U5p0AZypqdFqdP+9B6wM7Swg9fjK0oTKPYc
 ljXQsDq7Qd+nCRPH0G+0gQzM5NUVRFxv+nHl58SCVZFUaqwsFk
 BEjo3l6Yge+7EMINgj8JNTaUZEz7moTm3re3eVWYtJCxwZ9cia
 IFB0Er9qf29MrTVbFFuTlOaULGLN88dzCXfpr8BHb1g1bNOdwd
 J59hqMN7oz6mHaxpuucc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2013 16:34:59 Heiko Carstens wrote:
> 
> E.g. readl is defined like this
> 
>  #define readl(addr) __le32_to_cpu(__raw_readl(addr))
> 
> If there is a readl() call that doesn't check the return value
> this will cause a compile warning on big endian machines due to
> the __le32_to_cpu macro magic.
> 
> E.g. code like this:
> 
>         readl(addr);
> 
> will generate the following compile warning:
> 
> warning: value computed is not used [-Wunused-value]
> 
> Convert the defines to functions so we get rid of these warnings.
> With this patch we get rid of dozens of compile warnings on s390.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

if you fix this:

> +#define readl readl
> +static inline u32 __raw_readl(const volatile void __iomem *addr)
> +{
> +       return __le32_to_cpu(__raw_readl(addr));
> +}
 
to be called readl rather than __raw_readl

	Arnd
