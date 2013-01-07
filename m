Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3AGKYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:24:21 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:49792 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3AGKYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:24:20 -0500
MIME-Version: 1.0
In-Reply-To: <1357553025-21094-1-git-send-email-s.hauer@pengutronix.de>
References: <1357553025-21094-1-git-send-email-s.hauer@pengutronix.de>
Date: Mon, 7 Jan 2013 08:16:02 -0200
Message-ID: <CAOMZO5Cpa2OYd+v=wE4hbw=sjmQk+bP1HrY49PEWmwRyiVD1dg@mail.gmail.com>
Subject: Re: [PATCH] [media] coda: Fix build due to iram.h rename
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Mon, Jan 7, 2013 at 8:03 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> commit c045e3f13 (ARM: imx: include iram.h rather than mach/iram.h) changed the
> location of iram.h, which causes the following build error when building the coda
> driver:
>
> drivers/media/platform/coda.c:27:23: error: mach/iram.h: No such file or directory
> drivers/media/platform/coda.c: In function 'coda_probe':
> drivers/media/platform/coda.c:2000: error: implicit declaration of function 'iram_alloc'
> drivers/media/platform/coda.c:2001: warning: assignment makes pointer from integer without a cast
> drivers/media/platform/coda.c: In function 'coda_remove':
> drivers/media/platform/coda.c:2024: error: implicit declaration of function 'iram_free'
>
> Since the content of iram.h is not imx specific, move it to
> include/linux/platform_data/imx-iram.h instead. This is an intermediate solution
> until the i.MX iram allocator is converted to the generic SRAM allocator.
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>
> Based on an earlier version from Fabio Estevam, but this one moves iram.h
> to include/linux/platform_data/imx-iram.h instead of include/linux/iram.h
> which is a less generic name.
>
>  arch/arm/mach-imx/iram.h               |   41 --------------------------------
>  arch/arm/mach-imx/iram_alloc.c         |    3 +--
>  drivers/media/platform/coda.c          |    2 +-
>  include/linux/platform_data/imx-iram.h |   41 ++++++++++++++++++++++++++++++++
>  4 files changed, 43 insertions(+), 44 deletions(-)
>  delete mode 100644 arch/arm/mach-imx/iram.h
>  create mode 100644 include/linux/platform_data/imx-iram.h

It would be better to use git mv /git format-patch -M, so that git can
detect the file rename.

Regards,

Fabio Estevam
