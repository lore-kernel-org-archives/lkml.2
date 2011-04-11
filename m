Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1DKPLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:11:50 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:43770 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab1DKPLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:11:49 -0400
Message-ID: <4bd170057af715738bbc818219dffc04.squirrel@webmail.sf-mail.de>
In-Reply-To: <1302514324-14717-2-git-send-email-joerg.roedel@amd.com>
References: <1302514324-14717-1-git-send-email-joerg.roedel@amd.com>
    <1302514324-14717-2-git-send-email-joerg.roedel@amd.com>
Date: Mon, 11 Apr 2011 15:11:44 -0000
Subject: Re: [PATCH 1/2] x86/amd-iommu: Add extended feature detection
From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
To: "Joerg Roedel" <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, "Joerg Roedel" <joerg.roedel@amd.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds detection of the extended features of an
> AMD IOMMU. The available features are printed to dmesg on
> boot.

> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index bcf58ea..d609610 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -29,8 +29,8 @@
>  #include <asm/proto.h>
>  #include <asm/iommu.h>
>  #include <asm/gart.h>
> -#include <asm/amd_iommu_proto.h>
>  #include <asm/amd_iommu_types.h>
> +#include <asm/amd_iommu_proto.h>
>  #include <asm/amd_iommu.h>

That one (and the second place where this happens later) look suspicious.
Do you need that change? Usually those includes tend to be alphabetically
sorted (which you destroy here).

When you _need_ that change that means that you probably use some things
from amd_iommu_types.h in amd_iommu_proto.h without including that header
there (which is a bug in amd_iommu_proto.h and must be fixed there).
Otherwise this change is just noise. So either way this change should not
happen IMHO.

Eike
