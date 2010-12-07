Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0LGP4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:56:48 -0500
Received: from www.tglx.de ([62.245.132.106]:42626 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab0LGP4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:56:47 -0500
Date: Tue, 7 Dec 2010 16:56:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Tang <feng.tang@intel.com>
cc: Yinghai Lu <yinghai@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/platform] x86: Unify current 3 similar ways of saving
 IRQ info
In-Reply-To: <20101207133204.4d913c5a@feng-i7>
Message-ID: <alpine.LFD.2.00.1012071654080.2653@localhost6.localdomain6>
References: <1291349518-3502-1-git-send-email-feng.tang@intel.com> <tip-a6427a341985e0379060c86b50fcdb59883e4102@git.kernel.org> <4CFD226C.60308@kernel.org> <20101207133204.4d913c5a@feng-i7>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Feng Tang wrote:
> On Tue, 7 Dec 2010 01:50:36 +0800
> Yinghai Lu <yinghai@kernel.org> wrote:
>  
> +static void assign_to_mp_irq(struct mpc_intsrc *m,
> +				    struct mpc_intsrc *mp_irq)
> +{
> +	mp_irq->dstapic = m->dstapic;
> +	mp_irq->type = m->type;
> +	mp_irq->irqtype = m->irqtype;
> +	mp_irq->irqflag = m->irqflag;
> +	mp_irq->srcbus = m->srcbus;
> +	mp_irq->srcbusirq = m->srcbusirq;
> +	mp_irq->dstirq = m->dstirq;

  Can we please use the mrst version with memcpy ?

> +}
> +
> +static int mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
> +					struct mpc_intsrc *m)
> +{
> +	if (mp_irq->dstapic != m->dstapic)
> +		return 1;
> +	if (mp_irq->type != m->type)
> +		return 2;
> +	if (mp_irq->irqtype != m->irqtype)
> +		return 3;
> +	if (mp_irq->irqflag != m->irqflag)
> +		return 4;
> +	if (mp_irq->srcbus != m->srcbus)
> +		return 5;
> +	if (mp_irq->srcbusirq != m->srcbusirq)
> +		return 6;
> +	if (mp_irq->dstirq != m->dstirq)
> +		return 7;
> +
> +	return 0;

  Same here. No caller is interested in the detailed return value.

Thanks,

	tglx
