Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945Ab2FVJtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 05:49:14 -0400
Received: from lebrac.rtp-net.org ([88.191.135.105]:56189 "EHLO
	lebrac.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761923Ab2FVJtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 05:49:13 -0400
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jun 2012 05:49:13 EDT
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Huacai Chen <chenhuacai@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>, Huacai Chen <chenhc@lemote.com>,
        Hongliang Tao <taohl@lemote.com>, Hua Yan <yanh@lemote.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH V3 11/16] drm/radeon: Make radeon card usable for Loongson.
Organization: RtpNet
References: <1340334073-17804-1-git-send-email-chenhc@lemote.com>
	<1340334073-17804-12-git-send-email-chenhc@lemote.com>
Date: Fri, 22 Jun 2012 11:39:19 +0200
In-Reply-To: <1340334073-17804-12-git-send-email-chenhc@lemote.com> (Huacai
	Chen's message of "Fri, 22 Jun 2012 11:01:08 +0800")
Message-ID: <87txy3sn20.fsf@lebrac.rtp-net.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Huacai Chen <chenhuacai@gmail.com> writes:

> 1, Handle io prot correctly for MIPS.
> 2, Define SAREA_MAX as the size of one page.
> 3, Don't use swiotlb on Loongson machines (Loonson need swioitlb, but
>    when use swiotlb, GPU reset occurs at resume from suspend).
>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Signed-off-by: Hongliang Tao <taohl@lemote.com>
> Signed-off-by: Hua Yan <yanh@lemote.com>
> Reviewed-by: Michel Dänzer <michel@daenzer.net>
> Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
> Reviewed-by: Lucas Stach <dev@lynxeye.de>
> Reviewed-by: j.glisse <j.glisse@gmail.com>
> Cc: dri-devel@lists.freedesktop.org
> ---
>  drivers/gpu/drm/drm_vm.c            |    2 +-
>  drivers/gpu/drm/radeon/radeon_ttm.c |    6 +++---
>  drivers/gpu/drm/ttm/ttm_bo_util.c   |    2 +-
>  include/drm/drm_sarea.h             |    2 ++
>  4 files changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
> index 961ee08..3f06166 100644
> --- a/drivers/gpu/drm/drm_vm.c
> +++ b/drivers/gpu/drm/drm_vm.c
> @@ -62,7 +62,7 @@ static pgprot_t drm_io_prot(uint32_t map_type, struct vm_area_struct *vma)
>  		tmp = pgprot_writecombine(tmp);
>  	else
>  		tmp = pgprot_noncached(tmp);
> -#elif defined(__sparc__) || defined(__arm__)
> +#elif defined(__sparc__) || defined(__arm__) || defined(__mips__)
>  	tmp = pgprot_noncached(tmp);

btw, would it be a good idea to use uncached accelerated instead ?

Arnaud
