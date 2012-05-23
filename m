Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966Ab2EWTY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:24:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:46397 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933927Ab2EWTY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:24:26 -0400
Date: Wed, 23 May 2012 21:24:12 +0200 (CEST)
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
In-Reply-To: <20120523190414.GA5263@sgi.com>
Message-ID: <alpine.LFD.2.02.1205232107120.3231@ionos>
References: <20120521164959.GE16454@sgi.com> <alpine.LFD.2.02.1205212304580.3231@ionos> <20120521211917.GA25567@sgi.com> <alpine.LFD.2.02.1205212324260.3231@ionos> <20120523181636.GA2032@sgi.com> <20120523190414.GA5263@sgi.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Dimitri Sivanich wrote:

> On Wed, May 23, 2012 at 01:16:36PM -0500, Dimitri Sivanich wrote:
> > In create_irq_nr() there is a window where we have set vector_irq in
> > __assign_irq_vector(), but not yet called irq_set_chip_data() to set the
> > irq_cfg pointer.
> 
> BTW - is there a reason why we're calling irq_set_chip_data() in create_irq_nr()
> rather than in __assign_irq_vector() for the case where irq_cfg is NULL?

We can't nest desc->lock inside vector lock.
