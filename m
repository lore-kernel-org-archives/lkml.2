Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0K0Pjp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 10:39:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55165 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab0K0Pjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 10:39:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI Bus
Date: Sat, 27 Nov 2010 16:39:21 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: =?iso-8859-2?q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com> <alpine.LNX.2.00.1011271306420.7659@localhost.localdomain> <AANLkTinbAVFE+HZrx+9KUwx8=MKFHPqrhpOpAWAEQFv-@mail.gmail.com>
In-Reply-To: <AANLkTinbAVFE+HZrx+9KUwx8=MKFHPqrhpOpAWAEQFv-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8bit
Message-Id: <201011271639.21694.arnd@arndb.de>
X-Provags-ID: V02:K0:gF0evulAH53cQMim5lRXhq/5o5qlos6eOCV4yxBvgcG
 G9BErt3pZ/6u4H3rBHln6O4TWjDkCD4GDRHpmEpRQQ0jhpUpUM
 yBXAtjDn7tz59JweAUhqkuY9fPkATVjMyWV7z7DQzmTQ+0Fl0t
 VDZcbN7TY6XULMhmpFOEoZIDLjPkmHCnnCw83NanUxct6Kpl0U
 lu1E5ilEiwy1qsYYl0stw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 November 2010 14:01:20 Micha³ Miros³aw wrote:
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index db524e7..74ea522 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1164,7 +1164,7 @@ config ISA_DMA_API
>         bool
> 
>  config PCI
> -       bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB ||
> ARCH_IXP4XX || ARCH_KS8695 || MACH_ARMCORE || ARCH_CNS3XXX
> +       bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB ||
> ARCH_IXP4XX || ARCH_KS8695 || MACH_ARMCORE || ARCH_CNS3XXX ||
> ARCH_GEMINI
>         help
>           Find out whether you have a PCI motherboard. PCI is the name of a
>           bus system, i.e. the way the CPU talks to the other stuff inside
> 

This approach really does not scale as we add more boards to the list.

Better make a new CONFIG_HAVE_PCI option that you can select from the
individual boards, and make that the only dependency that CONFIG_PCI has.

	Arnd
