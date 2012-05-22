Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab2EVClG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:41:06 -0400
Received: from relay3.sgi.com ([192.48.152.1]:34036 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755626Ab2EVClE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:41:04 -0400
Date: Mon, 21 May 2012 21:41:01 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: check for valid irq_cfg pointer in
 smp_irq_move_cleanup_interrupt
Message-ID: <20120522024101.GA30298@sgi.com>
References: <20120521164959.GE16454@sgi.com>
 <1337634353.1997.144.camel@sbsiddha-desk.sc.intel.com>
 <20120521210901.GA25326@sgi.com>
 <1337634639.1997.148.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337634639.1997.148.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 02:10:39PM -0700, Suresh Siddha wrote:
> On Mon, 2012-05-21 at 16:09 -0500, Dimitri Sivanich wrote:
> > On Mon, May 21, 2012 at 02:05:53PM -0700, Suresh Siddha wrote:
> > > On Mon, 2012-05-21 at 11:49 -0500, Dimitri Sivanich wrote:
> > > > The smp_irq_move_cleanup_interrupt routine should be checking for a valid
> > > > irq_cfg pointer prior to accessing it.  It also seems that this should be
> > > > done after taking the desc lock.
> > > 
> > > I think these changes are correct. Did you see any crashes during module
> > > unload etc?
> > 
> > Yes, we have seen these on occasion during boot.
> 
> During boot or shutdown?
> 
Early on in boot, on rare occasions.

Easiest to reproduce doing module repeated module loads/unloads.

> Review of the code shows that this can trigger during module unload
> which can call destroy_irq() etc and can trigger the crash if there is a
> parallel irq migration related cleanup.
> 
> Unsuccessful module loads can also call destroy_irq() but I doubt that
> is what happening here.
> 
> thanks,
> suresh
> 
