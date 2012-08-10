Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2HJHfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 03:35:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65361 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991Ab2HJHfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 03:35:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 10/11] spi/s3c64xx: improve error handling
Date: Fri, 10 Aug 2012 07:34:46 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Jaswinder Singh'" <jaswinder.singh@linaro.org>,
        "'Grant Likely'" <grant.likely@secretlab.ca>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de> <1344437248-20560-11-git-send-email-arnd@arndb.de> <0de501cd76c2$ea07dfd0$be179f70$%kim@samsung.com>
In-Reply-To: <0de501cd76c2$ea07dfd0$be179f70$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208100734.47339.arnd@arndb.de>
X-Provags-ID: V02:K0:axpDMkdr5JhOSwYocHKbt18DX+nK383FyivP5DC4kHI
 94l2nglgkdFlSW2I5j+fcr7zJOvXC7s03J8Vk8fUBWJbrdwJqK
 3O25nN0TNSmBXVLhKKj9ouBe8VuGn6Eqazod6UW/5sr8F+snd1
 T8+qQhxP9vJQ5t4sGSnm6mEMfpNEU+J00nTxUqh4c/S6Zif3q0
 0iLk9waMAQ3RsobYz/jop5Bb3efI6ymHJ5fDAC6LZk0gu0TLLB
 YLKfx+84IhEpy6zlfZLJuEwJPN5/sssWfAaksTFg0r5fqzd+dg
 25A/N9t7pV6G3lsw+ANzaTlh3jWTXL/aLIGcnbQh7foumlHUW4
 wB+jyS0P7I1cdJZMs9IE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 August 2012, Kukjin Kim wrote:

> BTW for same reason, probably, we need following fix?
> 
>  arch/arm/mach-tegra/tegra2_emc.c             |    4 ++--
>  arch/c6x/kernel/setup.c                      |    2 +-
>  arch/powerpc/kernel/ibmebus.c                |    2 +-
>  arch/powerpc/kernel/pci_of_scan.c            |    2 +-
>  arch/powerpc/kernel/prom.c                   |    2 +-
>  arch/powerpc/kernel/rtas_pci.c               |    2 +-
>  arch/powerpc/kernel/vio.c                    |    2 +-
>  arch/powerpc/platforms/44x/warp.c            |    2 +-
> ...

Actually not. The difference is that only s3c64xx_get_slave_ctrldata
accesses the node pointer outside of the look (after break).
This fails when there are no child nodes at all. In the other
cases, the only use of the node pointer is inside the loop,
where it is guaranteed to be valid.

	Arnd
