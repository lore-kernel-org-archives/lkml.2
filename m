Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2A3R2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:28:45 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:38326 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216Ab2A3R2n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:28:43 -0500
MIME-Version: 1.0
In-Reply-To: <1ceb6f764f01fce26243d899d899f84ad26e4bd4.1327348286.git.vjaquez@igalia.com>
References: <cover.1327348286.git.vjaquez@igalia.com>
	<1ceb6f764f01fce26243d899d899f84ad26e4bd4.1327348286.git.vjaquez@igalia.com>
Date: Mon, 30 Jan 2012 11:28:37 -0600
Message-ID: <CAB-zwWijsdydtK09h41ogkp+vgsbqL5eyneVQcNT1ehupGFS9A@mail.gmail.com>
Subject: Re: [PATCH 4/5] staging: tidspbridge: silence the compiler
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: =?ISO-8859-1?Q?V=EDctor_Manuel_J=E1quez_Leal?= <vjaquez@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/23 Víctor Manuel Jáquez Leal <vjaquez@igalia.com>:
> Silence the warning when compiling drv_interface.c
>
> Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
> ---
>  drivers/staging/tidspbridge/rmgr/drv_interface.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
> index c7015f5..3bbe443 100644
> --- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
> +++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
> @@ -273,8 +273,9 @@ static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
>        vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>
>        dev_dbg(bridge, "%s: vm filp %p offset %x start %lx end %lx page_prot "
> -               "%lx flags %lx\n", __func__, filp, offset,
> -               vma->vm_start, vma->vm_end, vma->vm_page_prot, vma->vm_flags);
> +               "%ulx flags %lx\n", __func__, filp, offset,
> +               vma->vm_start, vma->vm_end, vma->vm_page_prot,
> +               vma->vm_flags);
>
>        status = remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>                                 vma->vm_end - vma->vm_start,
> --
> 1.7.8.3
>

Looks good.

Regards,

Omar
