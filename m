Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab1COBfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 21:35:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24515 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab1COBft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 21:35:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6285"; a="79751767"
Message-ID: <4D7EC274.4020407@codeaurora.org>
Date: Mon, 14 Mar 2011 18:35:48 -0700
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sheetal Sahasrabudhe <sheetals@codeaurora.org>
CC: linux-arm-kernel@lists.infradead.org, will.deacon@arm.com,
        jamie.iles@picochip.com, jean.pihet@newoldbits.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] [ARM] perfevents: Add support for Scorpion performance
 monitors
References: <1299608733-28514-1-git-send-email-sheetals@codeaurora.org> <1299691007-13470-1-git-send-email-sheetals@codeaurora.org>
In-Reply-To: <1299691007-13470-1-git-send-email-sheetals@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 09:16 AM, Sheetal Sahasrabudhe wrote:
> This commit adds support for performance monitors provided by
> Qualcomm Scorpion and ScorpionMP processor to perfevents.
> 
> Signed-off-by: Sheetal Sahasrabudhe <sheetals@codeaurora.org>
> Reviewed-by: Jean Pihet <j-pihet@ti.com>
> Reviewed-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm/include/asm/perf_event.h |    2 +
>  arch/arm/kernel/perf_event.c      |   11 +
>  arch/arm/kernel/perf_event_msm.c  |  679 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 692 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/kernel/perf_event_msm.c
> 

...

> diff --git a/arch/arm/kernel/perf_event_msm.c b/arch/arm/kernel/perf_event_msm.c
> new file mode 100644
> index 0000000..4e42f27
> --- /dev/null
> +++ b/arch/arm/kernel/perf_event_msm.c
> @@ -0,0 +1,679 @@
> +/*
> + * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <asm/vfp.h>
> +#include <asm/system.h>
> +#include "../vfp/vfpinstr.h"

Sorry I didn't see this earlier.  Is there another way to get the info
you need that wouldn't use a relative include path?  If the info from
vfpinstr.h is now needed outside of the vfp directory, can it be moved
to a common header instead?  Thanks.

- Bryan


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
