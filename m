Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605Ab1JGFK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 01:10:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55574 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759556Ab1JGFKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 01:10:22 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-8-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-8-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 7 Oct 2011 13:10:02 +0800
Message-ID: <CAMPhdO8cX7e1NbxoJ_qVvmhMxkeURuw8akMY17j9_csskW+p6A@mail.gmail.com>
Subject: Re: [PATCH 07/26] ARM: pxa: mbxfb: disable broken debugfs code
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> This code has not worked for a long time, and even the
> Makefile entry for building the file was misspelled.
> Mark it as broken.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  drivers/video/Kconfig      |    2 +-
>  drivers/video/mbx/Makefile |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 549b960..45494c0 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -1932,7 +1932,7 @@ config FB_MBX
>
>  config FB_MBX_DEBUG
>        bool "Enable debugging info via debugfs"
> -       depends on FB_MBX && DEBUG_FS
> +       depends on FB_MBX && DEBUG_FS && BROKEN
>        default n
>        ---help---
>          Enable this if you want debugging information using the debug
> diff --git a/drivers/video/mbx/Makefile b/drivers/video/mbx/Makefile
> index 16c1165..a315abc 100644
> --- a/drivers/video/mbx/Makefile
> +++ b/drivers/video/mbx/Makefile
> @@ -1,4 +1,4 @@
>  # Makefile for the 2700G controller driver.
>
>  obj-$(CONFIG_FB_MBX)      += mbxfb.o
> -obj-$(CONFIG_FB_MBX_DEBUG) += mbxfbdebugfs.o
> +obj-$(CONFIG_FB_MBX_DEBUG) += mbxdebugfs.o
> --
> 1.7.5.4
>
>
