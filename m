Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761182Ab2CNTLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 15:11:04 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:7468 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab2CNTLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 15:11:01 -0400
Message-ID: <4F60ED44.70808@tilera.com>
Date: Wed, 14 Mar 2012 15:11:00 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile_edac: Fix the memory controller ID
References: <1331560917-14071-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331560917-14071-1-git-send-email-mchehab@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/2012 10:02 AM, Mauro Carvalho Chehab wrote:
> Fix a regression introduced by changeset 7b03829a8ba4:
>
> -       mci = edac_mc_alloc(sizeof(struct tile_edac_priv),
> -               TILE_EDAC_NR_CSROWS, TILE_EDAC_NR_CHANS, pdev->id);
> +       mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false,
> +                           sizeof(struct tile_edac_priv));
>
> The pdev->id is missing.
>
> Compile-tested only. Btw, in order to compile it, I had to:
>
> 1) comment a header at arch/tile/include/asm/linkage.h:
>
> 	-#include <feedback.h>
> 	+//#include <feedback.h>
>
> 2) Use the ./arch/tile/configs/tilegx_defconfig . the tilepro_defconfig
>    is broken;
>
> 3) manually enable the EDAC module on it.
>
> Somebody has to fix it ;)
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

You might amend the commit message based on our conversation, but otherwise:

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

Thanks for fixing up the tile EDAC driver, BTW :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

