Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab2AQQ3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:29:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067Ab2AQQ3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:29:01 -0500
Date: Tue, 17 Jan 2012 08:28:50 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sergei Trofimovich <slyich@gmail.com>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>, justinmattock@gmail.com,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] mce: fix warning messages about static struct mce_device
Message-ID: <20120117162850.GA19561@suse.de>
References: <20120116224028.GA5072@suse.de>
 <20120117083843.GC13181@elte.hu>
 <20120117155125.GB13778@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117155125.GB13778@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 07:51:25AM -0800, Greg KH wrote:
> On Tue, Jan 17, 2012 at 09:38:43AM +0100, Ingo Molnar wrote:
> > 
> > * Greg KH <gregkh@suse.de> wrote:
> > 
> > > diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> > > index f35ce43..6aefb14 100644
> > > --- a/arch/x86/include/asm/mce.h
> > > +++ b/arch/x86/include/asm/mce.h
> > > @@ -151,7 +151,7 @@ static inline void enable_p5_mce(void) {}
> > >  
> > >  void mce_setup(struct mce *m);
> > >  void mce_log(struct mce *m);
> > > -DECLARE_PER_CPU(struct device, mce_device);
> > > +extern struct device *mce_device[CONFIG_NR_CPUS];
> > 
> > Minor nit, i don't think we have any other such [CONFIG_NR_CPUS] 
> > pattern in the kernel.
> > 
> > This should be something like:
> > 
> >   DECLARE_PER_CPU(struct device *, mce_device);
> 
> That is what we used to have, but with just a static struct device.  We
> really don't need this to be in the per-cpu area, a flat array should be
> just fine, why can't we use the CONFIG_NR_CPUS value?  Should we use
> something else?
> 
> > Or the pointer should be attached to the CPU info structure.
> 
> Ok, I have no objection to that, do you want me to make a patch doing
> that, now that this is already in Linus's tree?

Wait, isn't that variable also used in head.S, so do you really want a
struct device * in there?

thanks,

greg k-h
