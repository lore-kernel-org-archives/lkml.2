Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab2C2J7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:59:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:51047 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab2C2J7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:59:05 -0400
Date: Thu, 29 Mar 2012 11:58:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <liuj97@gmail.com>
cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Jes Sorensen <jes@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Meyer <thomas@m3y3r.de>,
        Jiang Liu <jiang.liu@huawei.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-altix@sgi.com, x86@kernel.org,
        chenkeping@huawei.com
Subject: Re: [PATCH] IRQ: normalize chip->irq_set_affinity return value on
 x86 and IA64
In-Reply-To: <1331046112-19526-1-git-send-email-jiang.liu@huawei.com>
Message-ID: <alpine.LFD.2.02.1203291154010.2542@ionos>
References: <1331046112-19526-1-git-send-email-jiang.liu@huawei.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012, Jiang Liu wrote:

> On x86 and IA64 platforms, interrupt controller chip's irq_set_affinity()
> method always copies affinity mask to irq_data->affinity field but still
> returns 0(IRQ_SET_MASK_OK). That return value causes the interrupt core
> logic unnecessarily copies the mask to irq_data->affinity field again.
> So return IRQ_SET_MASK_OK_NOCOPY instead of IRQ_SET_MASK_OK to get rid of
> the duplicated copy operation.
> 
> This patch applies to v3.3-rc6 and has been tested on x86 platforms.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  arch/ia64/kernel/iosapic.c     |    4 +++-
>  arch/ia64/kernel/msi_ia64.c    |    4 ++--
>  arch/ia64/sn/kernel/irq.c      |    2 +-
>  arch/ia64/sn/kernel/msi_sn.c   |    2 +-
>  arch/x86/kernel/apic/io_apic.c |   11 ++++++-----
>  arch/x86/platform/uv/uv_irq.c  |    2 +-
>  kernel/irq/internals.h         |    3 +++
>  kernel/irq/manage.c            |   39 ++++++++++++++++++++++-----------------
>  kernel/irq/migration.c         |    6 +-----


This does not work that way. The patch wants to be split in 3 parts
(core, x86, ia64). The patches are completely independent. Please
resend.

Thanks,

	tglx
