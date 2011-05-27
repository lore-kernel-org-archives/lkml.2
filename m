Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab1E0RDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:03:47 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:48014 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab1E0RDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:03:43 -0400
Date: Fri, 27 May 2011 22:33:31 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        anderson@redhat.com
Subject: Re: [RFC Patch 4/6] PANIC_MCE: Introduce a new panic flag for fatal
 MCE, capture related information
Message-ID: <20110527170331.GD2384@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20110526170722.GB23266@in.ibm.com>
 <20110526171521.GD17988@in.ibm.com>
 <20110526184350.GE29496@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526184350.GE29496@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 02:43:50PM -0400, Vivek Goyal wrote:
> On Thu, May 26, 2011 at 10:45:21PM +0530, K.Prasad wrote:
> 
> [..]
> > Index: linux-2.6.slim_kdump/arch/x86/kernel/cpu/mcheck/mce.c
> > ===================================================================
> > --- linux-2.6.slim_kdump.orig/arch/x86/kernel/cpu/mcheck/mce.c
> > +++ linux-2.6.slim_kdump/arch/x86/kernel/cpu/mcheck/mce.c
> > @@ -258,8 +258,7 @@ static void wait_for_panic(void)
> >  	local_irq_enable();
> >  	while (timeout-- > 0)
> >  		udelay(1);
> > -	xpanic(PANIC_NO_KEXEC|PANIC_NO_BACKTRACE, 0,
> > -		"Panicing machine check CPU died");
> > +	xpanic(PANIC_MCE, 0, NULL, 0, "Panicing machine check CPU died");
> >  }
> >  
> >  static void mce_panic(char *msg, struct mce *final, char *exp)
> > @@ -315,8 +314,8 @@ static void mce_panic(char *msg, struct
> >  	if (exp)
> >  		pr_emerg(HW_ERR "Machine check: %s\n", exp);
> >  	if (!fake_panic) {
> > -		xpanic(PANIC_NO_KEXEC|PANIC_NO_BACKTRACE, mce_panic_timeout,
> > -			msg);
> > +		xpanic(PANIC_MCE, mce_panic_timeout, final,
> > +			sizeof(struct mce), msg);
> >  	} else
> >  		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
> >  }
> 
> In previous patches you introduce PANIC_NO_KEXEC and PANIC_NO_BACKTRACE. 
> Now in this patch you got rid of those. Are there any other users left
> of PANIC_NO_BACKTRACE and PANIC_NO_EXEC? If not, then why to introduce
> these to begin with.
>

The previous patch also converts panic to xpanic and is taken from
Andi's
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git tree.
The changes are kept as two separate patches to identify their origin.

Thanks,
K.Prasad

 
