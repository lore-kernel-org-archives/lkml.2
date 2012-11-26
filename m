Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab2KZV7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:59:40 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34685 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab2KZV7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:59:38 -0500
MIME-Version: 1.0
In-Reply-To: <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
	<1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>
Date: Mon, 26 Nov 2012 15:59:37 -0600
Message-ID: <CAF6AEGu629qj-pgd5gaJEpo2QqqUZYXyDJk14c5rgdAwh-wMPg@mail.gmail.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
From: Rob Clark <robdclark@gmail.com>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: thierry.reding@avionic-design.de, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Arto Merilainen <amerilainen@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 7:19 AM, Terje Bergstrom <tbergstrom@nvidia.com> wrote:
>
> +struct tegra_drm_submit_args {
> +       void *context;

Just a quick comment..

You shouldn't really use ptr here, but instead use a 64bit type so
that you don't run into issues later for armv8/64bit.  Same comment
applies in a few other places too.

I'll try and spend a bit more time going through this in more detail
in the coming days

BR,
-R

> +       __u32 num_syncpt_incrs;
> +       __u32 num_cmdbufs;
> +       __u32 num_relocs;
> +       __u32 submit_version;
> +       __u32 num_waitchks;
> +       __u32 waitchk_mask;
> +       __u32 timeout;
> +       struct tegra_drm_syncpt_incrs *syncpt_incrs;
> +       struct tegra_drm_cmdbuf *cmdbufs;
> +       struct tegra_drm_reloc *relocs;
> +       struct tegra_drm_waitchk *waitchks;
> +
> +       __u32 pad[5];           /* future expansion */
> +       __u32 fence;            /* Return value */
> +};
> +
