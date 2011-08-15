Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab1HOJA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 05:00:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60589 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1HOJA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 05:00:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Leo Yan <leoy@marvell.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <hzhuang1@marvell.com>
Subject: Re: [PATCH 1/3] ARM: mmp: add sram allocator
Date: Mon, 15 Aug 2011 10:59:55 +0200
Message-ID: <1403041.Yj2MdIhcZO@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <1313377794-26721-2-git-send-email-leoy@marvell.com>
References: <1313377794-26721-1-git-send-email-leoy@marvell.com> <1313377794-26721-2-git-send-email-leoy@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:40W9JkVThO6WkD8bQONgI997hKuBKCGKV+djik6dYA2
 8sP46fY+jTivkeyTqg75z7K1FsFOJDrC9sCZMp88zpc/BRCrTU
 f0c4LtpJw5hcJRIjtfwx7NVSZ3+qR0c9VG+pWw59jlghYLtT9H
 /7w8/4ZtYHkdlS7CQl631vgy5snx96ckirQUEL5iP4hbz3JBsT
 u+5JwbXQO+Uwogqubw3sQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 August 2011 11:09:52 Leo Yan wrote:
> On mmp platform, there have two sram banks:
> audio sram and internal sram. The audio sram is mainly for audio;
> the internal sram is for video, wtm and power management.
> So add the sram allocator using genalloc to manage them.
> 
> Every sram bank will register its own platform device
> info, after the sram allocator create the generic pool
> for the sram bank, the user module can use the pool's
> name to get the pool handler; then it can use the handler
> to alloc/free memory with genalloc APIs.
> 
> Signed-off-by: Leo Yan <leoy@marvell.com>
> ---
>  arch/arm/Kconfig                      |    1 +
>  arch/arm/mach-mmp/Makefile            |    2 +-
>  arch/arm/mach-mmp/include/mach/sram.h |   35 +++++++
>  arch/arm/mach-mmp/sram.c              |  168 +++++++++++++++++++++++++++++++++
>  4 files changed, 205 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/mach-mmp/include/mach/sram.h
>  create mode 100644 arch/arm/mach-mmp/sram.c

Some time ago, there was talk of merging the existing sram drivers
and creating a common driver that is easy to hook into.

What has happened with that? My feeling is that we should stop adding
more drivers like this in the platform code but rather put an
authoritative copy into arch/arm/mm/ or even the top-level mm/ directory
and change over the existing drivers to hook into that one.

	Arnd
