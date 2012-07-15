Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab2GOJKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 05:10:46 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49492 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab2GOJKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 05:10:38 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.44.123]
In-Reply-To: <1337515228-31910-1-git-send-email-ohad@wizery.com>
References: <1337515228-31910-1-git-send-email-ohad@wizery.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 15 Jul 2012 12:10:17 +0300
Message-ID: <CAK=WgbZVUEWErthGz0ch-fFkZAEMU0unqPPXCZ5AXVa-8a3=_A@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: allocate vrings on demand, free when not needed
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Michal Simek <monstr@monstr.eu>, Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2012 at 3:00 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Dynamically allocate the vrings' DMA when the remote processor
> is about to be powered on (i.e. when ->find_vqs() is invoked),
> and release them as soon as it is powered off (i.e. when ->del_vqs()
> is invoked).
>
> The obvious and immediate benefit is better memory utilization, since
> memory for the vrings is now only allocated when the relevant remote
> processor is being used.
>
> Additionally, this approach also makes recovery of a (crashing)
> remote processor easier: one just needs to remove the relevant
> vdevs, and the entire vrings cleanup takes place automagically.
>
> Tested-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  drivers/remoteproc/remoteproc_core.c     |  109 +++++++++++++++---------------
>  drivers/remoteproc/remoteproc_internal.h |    2 +
>  drivers/remoteproc/remoteproc_virtio.c   |   13 +++-
>  3 files changed, 67 insertions(+), 57 deletions(-)

Applied.
