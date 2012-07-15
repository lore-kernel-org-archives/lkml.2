Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab2GOJRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 05:17:30 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48879 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab2GOJRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 05:17:22 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.44.123]
In-Reply-To: <1338017791-9442-2-git-send-email-ohad@wizery.com>
References: <1338017791-9442-1-git-send-email-ohad@wizery.com> <1338017791-9442-2-git-send-email-ohad@wizery.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 15 Jul 2012 12:17:01 +0300
Message-ID: <CAK=WgbZdaBCC8xc1iDRtoFLy=5nY4vsGWtZwYusvH4x8qjpcQA@mail.gmail.com>
Subject: Re: [PATCH 2/2] remoteproc: remove the now-redundant kref
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ohad Ben-Cohen <ohad@wizery.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 10:36 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Now that every rproc instance contains a device, we don't need a
> kref anymore to maintain the refcount of the rproc instances:
> that's what device are good with!
>
> This patch removes the now-redundant kref, and switches to
> {get, put}_device instead of kref_{get, put}.
>
> We also don't need the kref's release function anymore, and instead,
> we just utilize the class's release handler (which is now responsible
> for all memory de-allocations).
>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  drivers/remoteproc/remoteproc_core.c   |   59 +++++++++++---------------------
>  drivers/remoteproc/remoteproc_virtio.c |    8 ++--
>  include/linux/remoteproc.h             |    3 --
>  3 files changed, 24 insertions(+), 46 deletions(-)

Applied (after moving the kerneldoc for rproc_class_release() to the
patch where that function was introduced).
