Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2ILHbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 03:31:08 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38442 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2ILHbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 03:31:06 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.103.139]
In-Reply-To: <1346680105-4764-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1346680105-4764-1-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 12 Sep 2012 10:30:45 +0300
Message-ID: <CAK=WgbY_4QBjWXyv=NQLADWnkHBOEVsWwTfjFK=B_R39BY-aXg@mail.gmail.com>
Subject: Re: [PATCH] remtoteproc: Export notification id range
To: sjur.brandeland@stericsson.com
Cc: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Mon, Sep 3, 2012 at 4:48 PM,  <sjur.brandeland@stericsson.com> wrote:
> diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
> index d5c2dbf..00e1674 100644
> --- a/drivers/remoteproc/remoteproc_core.c
> +++ b/drivers/remoteproc/remoteproc_core.c
> @@ -215,6 +215,9 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
>                 return ret;
>         }
>
> +       /* Store largest notifyid */
> +       rproc->max_notifyid = max(rproc->max_notifyid, notifyid);

For completeness, I think we probably also want to update max_notifyid
when a notifyid is removed (i.e. on rproc_free_vring).

Thanks,
Ohad.
