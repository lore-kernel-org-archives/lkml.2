Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab0HKDFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 23:05:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60095 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab0HKDFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 23:05:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] ARM: uaccess: Implement strict user copy checks
Date: Wed, 11 Aug 2010 05:04:59 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1280890950-19174-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1280890950-19174-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008110504.59957.arnd@arndb.de>
X-Provags-ID: V02:K0:5SiYPOh9Gz64WowchQOTiFSt5Gg3jK5Ayjekwxoh9rI
 QeH1HG35xm2MoB9IWSGbGxYzS/XLK+LPr4v+lfU33jc4AIpRTJ
 4CBf0nlC51qeCMCUPOQj7zqZUYSxIGBOD1bAvKu/ruQd+j2Dr1
 VIsphHpOjRcAYOgBgQ4tA1L4CG9Lp6r1e7VwEQ5VVOhOQBV06O
 YUSZcXhlMS8Hsfw1qxWxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 August 2010, Stephen Boyd wrote:
> +config DEBUG_STRICT_USER_COPY_CHECKS
> +       bool "Strict user copy size checks"
> +       depends on DEBUG_KERNEL
> +       help
> +         Enabling this option turns a certain set of sanity checks for user
> +         copy operations into compile time errors.
> +
> +         The copy_from_user() etc checks are there to help test if there
> +         are sufficient security checks on the length argument of
> +         the copy operation, by having gcc prove that the argument is
> +         within bounds.
> +
> +         If unsure, or if you run an older (pre 4.4) gcc, say N.
> +

Do you actually need to disable this if running an older gcc? AFAICT, it
should just have no effect at all in that case, so the comment is slightly
misleading.

Also, why turn this specific warning into an error but not any of the other
warnings? Some architectures (alpha, sparc, mips, powerpc, sh) simply turn
on -Werror for architecture specific code in general, which seems very
useful. We can also make that a config option (probably arch independent)
that we turn on for defconfig files that we know build without warnings.

Unfortunately, there is a number of device drivers that have never been
warning-free, so we can't just enable -Werror for all code.

	Arnd
