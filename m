Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323Ab2EUVeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:34:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:33639 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759292Ab2EUVes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:34:48 -0400
Date: Mon, 21 May 2012 23:34:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: check for valid irq_cfg pointer in
 smp_irq_move_cleanup_interrupt
In-Reply-To: <20120521211917.GA25567@sgi.com>
Message-ID: <alpine.LFD.2.02.1205212324260.3231@ionos>
References: <20120521164959.GE16454@sgi.com> <alpine.LFD.2.02.1205212304580.3231@ionos> <20120521211917.GA25567@sgi.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, Dimitri Sivanich wrote:

> On Mon, May 21, 2012 at 11:07:04PM +0200, Thomas Gleixner wrote:
> > On Mon, 21 May 2012, Dimitri Sivanich wrote:
> > 
> > > The smp_irq_move_cleanup_interrupt routine should be checking for a valid
> > > irq_cfg pointer prior to accessing it.  It also seems that this should be
> > > done after taking the desc lock.
> > 
> > It seems that you either missed or failed to explain why it should be
> > done _after_ taking the lock.
> > 
> > Changelogs matter, really.
> >
> How about this?
>
> The smp_irq_move_cleanup_interrupt routine should be checking for a valid
> irq_cfg pointer prior to accessing it.

Why should it?
 
> Follow the same protocol shown in irq_set_chip_data(), by taking the desc
> lock before accessing this location.

This is not a proper explanation. irq_set_chip_data() might be wrong
as well and aside of that it might be correct to ignore that protocol
in that particular situation.

What's wrong with adding the actual wreckage scenario _AND_ the
solution to the changelog so that a casual reader, who is not
completely familiar with the code can understand what you are trying
to solve?

Don't misunderstand me. The patch is correct, just the explanation
sucks.

Thanks,

	tglx
