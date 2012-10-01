Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab2JALFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 07:05:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45864 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2JALFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 07:05:47 -0400
MIME-Version: 1.0
In-Reply-To: <1348868177-21205-4-git-send-email-arnd@arndb.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
	<1348868177-21205-4-git-send-email-arnd@arndb.de>
Date: Mon, 1 Oct 2012 12:05:45 +0100
Message-ID: <CAFbHwiRGnhEf-3XJJJPrHwmQRj_YE2kCZaGURHDQcu=cj0zSHw@mail.gmail.com>
Subject: Re: [PATCH 03/12] mmc: dw_mmc: fix building exynos driver as a module
From: Will Newton <will.newton@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Chris Ball <cjb@laptop.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Will Newton <will.newton@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:36 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The MODULE_DEVICE_TABLE() entry in the dw_mmc_exynos driver
> points to the wrong symbol which results in a link error
> when building as a loadable module.
>
> Further, we get a warning about the driver_data being
> marked constant, which requires annotating a few pointers
> as const.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Will Newton <will.newton@imgtec.com>
> Cc: Jaehoon Chung <jh80.chung@samsung.com>
> Cc: Seungwon Jeon <tgih.jun@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: linux-mmc@vger.kernel.org
> ---
>  drivers/mmc/host/dw_mmc-exynos.c |    4 ++--
>  drivers/mmc/host/dw_mmc-pltfm.c  |    2 +-
>  drivers/mmc/host/dw_mmc-pltfm.h  |    2 +-
>  drivers/mmc/host/dw_mmc.c        |    2 +-
>  include/linux/mmc/dw_mmc.h       |    2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)

This looks ok to me, but I'll let one of the Exynos guys ack those
specific changes as I don't have the hardware.

There's already a patch for the dev_info warning in dw_mmc.c frm
Seungwon Jeon, and it seems to me like a separate change but I don't
really mind how it gets merged.
