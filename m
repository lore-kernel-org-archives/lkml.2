Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966317Ab2C3VXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:23:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:41224 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935395Ab2C3VXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:23:31 -0400
Date: Fri, 30 Mar 2012 23:23:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <liuj97@gmail.com>
cc: Jiang Liu <jiang.liu@huawei.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>, Cliff Wickman <cpw@sgi.com>,
        x86@kernel.org, Keping Chen <chenkeping@huawei.com>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] IRQ,x86: normalize return value of chip->irq_set_affinity()
 method
In-Reply-To: <1333120296-13563-4-git-send-email-jiang.liu@huawei.com>
Message-ID: <alpine.LFD.2.02.1203302320060.2542@ionos>
References: <1333120296-13563-1-git-send-email-jiang.liu@huawei.com> <1333120296-13563-4-git-send-email-jiang.liu@huawei.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012, Jiang Liu wrote:

> On x86 platforms, interrupt controller chip's irq_set_affinity() method
> always copies affinity mask to irq_data->affinity field but still returns

Now the question here is whether it copies the mask because it
modified the mask in some way and want to reflect the change back.

If it just copies the unmodified mask, then this patch is wrong. It
should remove the copy from the arch code and return IRQ_SET_MASK_OK
so the core code can take care of the copying.

Ditto for the ia64 one.

Thanks,

	tglx
