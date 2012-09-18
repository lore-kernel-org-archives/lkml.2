Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab2IREXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 00:23:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42540 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2IREXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 00:23:52 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.118.250]
In-Reply-To: <1347559440-6668-2-git-send-email-sjur.brandeland@stericsson.com>
References: <1347559440-6668-1-git-send-email-sjur.brandeland@stericsson.com> <1347559440-6668-2-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 18 Sep 2012 07:23:31 +0300
Message-ID: <CAK=WgbZShJsfFBEVHt0opgbRx5hzTUXBBnBktOuWqh=zx_qx-w@mail.gmail.com>
Subject: Re: [PATCHv2] remoteproc: Export notification id range
To: sjur.brandeland@stericsson.com
Cc: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Thu, Sep 13, 2012 at 9:03 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Some of the rproc drivers needs to know the range
> of the notification IDs used for notifying the device.
> Export a variable in struct rproc holding the
> largest allocated notification id.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> ---
...
>  void rproc_free_vring(struct rproc_vring *rvring)
>  {
> +       int i, maxid = 0;
> +       struct rproc_vdev *rvdev, *tmp;
>         int size = PAGE_ALIGN(vring_size(rvring->len, rvring->align));
>         struct rproc *rproc = rvring->rvdev->rproc;
>
>         dma_free_coherent(rproc->dev.parent, size, rvring->va, rvring->dma);
>         idr_remove(&rproc->notifyids, rvring->notifyid);
> +
> +       /* Iterate over the new set of rings to find the largest id */
> +       rvring->notifyid = 0;
> +       list_for_each_entry_safe(rvdev, tmp, &rproc->rvdevs, node)

Why do you need the safe variant here ?

> +               for (i = 0; i < RVDEV_NUM_VRINGS; i++)

Maybe instead of two nested loops, just use idr_for_each ?

Thanks,
Ohad.
