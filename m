Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab1C3Q2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:28:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:39424 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab1C3Q2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:28:43 -0400
Date: Wed, 30 Mar 2011 18:28:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] irq fixes for .39.rc
In-Reply-To: <AANLkTinnGfpVeugk4WOKeDAUQEuzBo75yCq_E73=w66V@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1103301827530.22418@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103301648460.22418@localhost6.localdomain6> <AANLkTinnGfpVeugk4WOKeDAUQEuzBo75yCq_E73=w66V@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-323634808-1301502520=:22418"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-323634808-1301502520=:22418
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Wed, 30 Mar 2011, Linus Torvalds wrote:

> On Wed, Mar 30, 2011 at 7:51 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Please pull the latest irq-fixes-for-linus git tree from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus
> 
> Hmm. This has a fundamental merge  conflict with BenH's tree that I just pulled.
> 
> You guys did different things in arch/powerpc/include/asm/qe_ic.h:
> 
>  - BenH has:
> 
>         -       struct qe_ic *qe_ic = get_irq_desc_data(desc);
>         +       struct qe_ic *qe_ic = irq_desc_get_chip_data(desc);
> 
>  - Thomas has:
> 
>         -       struct qe_ic *qe_ic = get_irq_desc_data(desc);
>         +       struct qe_ic *qe_ic = irq_desc_get_handler_data(desc);
> 
> Note the "chip_data" vs "handler_data" difference.
> 
> And when I tried to figure out which one is the correct one, I see that
> 
>  - qe_ic_host_map does:
> 
>         irq_set_chip_data(virq, qe_ic);
> 
>  - qe_ic_init does:
> 
>         irq_set_handler_data(qe_ic->virq_low, qe_ic);
>         ...
>                 irq_set_handler_data(qe_ic->virq_high, qe_ic);
> 
> which just makes me go "Somebody is really really confused".
> 
> The whole thing may mean that both handler_data and chip_data contains
> the right thing, but it still makes me go "WTF?".
> 
> Which way should I resolve it?

get_irq_desc_data() maps to irq_desc_get_handler_data() so Richards
resolution is correct even if the other might work as well.

Thanks,

	tglx
---1463795968-323634808-1301502520=:22418--
