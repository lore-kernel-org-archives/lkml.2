Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab0IGSKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 14:10:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38600 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757994Ab0IGSKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 14:10:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ht8AD9wK4t5YHI1//3FKcOEl+HbWdRDS79wNgyXz5FD3eOmg6GKr00sfLGiL44noJh
         PMGA4HPfgrN7iPSJVTIBcddkBwFl3zqD6q+Fre3dx+hQO2EADOE8NyPUqf0kE9eiM1gJ
         pm4SBhTItMxk/0hsAcUlIM2lD5QBAEKwE7MhE=
MIME-Version: 1.0
In-Reply-To: <1282845485-8991-10-git-send-email-konrad.wilk@oracle.com>
References: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
	<1282845485-8991-10-git-send-email-konrad.wilk@oracle.com>
Date: Tue, 7 Sep 2010 11:10:30 -0700
X-Google-Sender-Auth: 2W3Lr8xuX4ST13p4KzV9HWFOLyk
Message-ID: <AANLkTikcdyNP8x28u3-m0oNcOqSek=xwUn3wW-=3sqnY@mail.gmail.com>
Subject: Re: [PATCH 09/10] x86/VT-d: Make Intel VT-d IOMMU use IOMMU_INIT_* macros.
From: Tony Luck <tony.luck@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: hpa@zytor.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Len Brown <len.brown@intel.com>, Chris Wright <chrisw@sous-sol.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 10:58 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> We utilize the IOMMU_INIT macros to create this dependency:
...
>  drivers/pci/dmar.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
> index 5fa64ea..4ef56a0 100644
> --- a/drivers/pci/dmar.c
> +++ b/drivers/pci/dmar.c
> @@ -36,6 +36,7 @@
>  #include <linux/tboot.h>
>  #include <linux/dmi.h>
>  #include <linux/slab.h>
> +#include <asm/iommu_table.h>

This breaks ia64 - since you didn't make an asm/iommu_table.h for it :-(

Just copying the x86 one led to complaints about pci_swiotlb_detect_4gb()
not being declared ... so I think I need a bit more of the same infrastructure
you made of x86.

Pointers & hints please?

-Tony
