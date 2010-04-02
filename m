Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0DBS3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:29:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:62773 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab0DBS3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:29:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,354,1267430400"; 
   d="scan'208";a="786105399"
Subject: Re: BUG: null pointer deref in dmar_ir_support
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Jan.Grossmann@kielnet.net" <Jan.Grossmann@kielnet.net>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Woodhouse, David" <david.woodhouse@intel.com>,
       "Han, Weidong" <weidong.han@intel.com>,
       "Song, Youquan" <youquan.song@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100402182034.GA27304@elte.hu>
References: <4BAD1676.9090704@kielnet.net>
	 <1270057394.2866.9.camel@sbs-t61.sc.intel.com>
	 <4BB395B0.6090007@kielnet.net>
	 <1270083887.7835.78.camel@sbs-t61.sc.intel.com>
	 <20100402182034.GA27304@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 02 Apr 2010 11:28:33 -0700
Message-Id: <1270232913.2870.60.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-02 at 11:20 -0700, Ingo Molnar wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > @@ -1640,8 +1640,10 @@ int __init APIC_init_uniprocessor(void)
> >  	}
> >  #endif
> >  
> > +#ifndef CONFIG_SMP
> >  	enable_IR_x2apic();
> >  	default_setup_apic_routing();
> > +#endif
> 
> Instead of adding yet another ugly #ifdef please hide these details properly, 
> by making enable_IR_x2apic() and default_setup_apic_routing() a NOP on !SMP.

Ingo, These are not nops on !SMP. We should call these functions from
APIC_init_uniprocessor() only if it is a UP kernel. For SMP kernel they
are called from some where else.

With the current code, on SMP and with non SMP motherboard we were
calling these routines twice which cause problem.

I wanted to keep the patch simple for urgent/backport. I will clean this
by restructuring the init code for 2.6.35

thanks,
suresh

