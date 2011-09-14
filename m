Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab1INMDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 08:03:15 -0400
Received: from alius.ayous.org ([78.46.213.165]:32967 "EHLO alius.ayous.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756409Ab1INMDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 08:03:14 -0400
X-Greylist: delayed 1888 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Sep 2011 08:03:14 EDT
Date: Wed, 14 Sep 2011 13:31:34 +0200
From: Andreas Barth <aba@not.so.argh.org>
To: keguang.zhang@gmail.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, wuzhangjin@gmail.com, r0bertz@gentoo.org,
        chenj@lemote.com
Subject: Re: [PATCH] MIPS: Add basic support for Loongson1B
Message-ID: <20110914113134.GS15003@mails.so.argh.org>
References: <1315997270-14332-1-git-send-email-keguang.zhang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315997270-14332-1-git-send-email-keguang.zhang@gmail.com>
X-Editor: Vim http://www.vim.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* keguang.zhang@gmail.com (keguang.zhang@gmail.com) [110914 12:49]:
> This patch adds basic support for Loongson1B
> including serial, timer and interrupt handler.

I have a couple of questions. One of them is if it shouldn't be
possible to add this as part of the loongson-platform, and if we
really need a new platform. Each platform comes with some maintainence
costs which we should try to avoid. Making things more generic is
usually the right answer.


> diff --git a/arch/mips/include/asm/mach-loongson1/irq.h b/arch/mips/include/asm/mach-loongson1/irq.h
> new file mode 100644
> index 0000000..44cec4a
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-loongson1/irq.h
> @@ -0,0 +1,70 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * Register mappings for Loongson1.

Can't we do the mapping via device trees, or are we not there yet?


> --- /dev/null
> +++ b/arch/mips/loongson1/common/clock.c
> @@ -0,0 +1,164 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>

Is this file not derived from any of the clock drivers we already have
in Linux?

Doesn't any of the existing clock drivers work? 

Is this clock part of the CPU? Otherwise it would make sense to move
it out to the generic drivers section.

> --- /dev/null
> +++ b/arch/mips/loongson1/common/irq.c
> @@ -0,0 +1,132 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * Based on Copyright (C) 2009 Lemote Inc.

same question here. Also, do you have permission from Lemote to put
the code within GPLv2?


> diff --git a/arch/mips/loongson1/common/prom.c b/arch/mips/loongson1/common/prom.c
> new file mode 100644
> index 0000000..84a25f6
> --- /dev/null
> +++ b/arch/mips/loongson1/common/prom.c

Can't we re-use the prom-routines from the loongson platform here? Or
even better, factor them out somewhere else in the mips or even
generic linux tree?

> index 0000000..b34ad35
> --- /dev/null
> +++ b/arch/mips/loongson1/common/reset.c


> +static void loongson1_halt(void)
> +{
> +	pr_notice("\n\n** You can safely turn off the power now **\n\n");
> +	while (1) {
> +		if (cpu_wait)
> +			cpu_wait();
> +	}
> +}


This code looks familiar to me, i.e. it shouldn't be
platform-specific.




Andi
