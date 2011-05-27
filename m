Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab1E0S3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:29:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab1E0S31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:29:27 -0400
Date: Fri, 27 May 2011 14:29:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        anderson@redhat.com
Subject: Re: [RFC Patch 4/6] PANIC_MCE: Introduce a new panic flag for fatal
 MCE, capture related information
Message-ID: <20110527182907.GI8053@redhat.com>
References: <20110526170722.GB23266@in.ibm.com>
 <20110526171521.GD17988@in.ibm.com>
 <20110526184350.GE29496@redhat.com>
 <20110527170331.GD2384@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527170331.GD2384@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 10:33:31PM +0530, K.Prasad wrote:
> On Thu, May 26, 2011 at 02:43:50PM -0400, Vivek Goyal wrote:
> > On Thu, May 26, 2011 at 10:45:21PM +0530, K.Prasad wrote:
> > 
> > [..]
> > > Index: linux-2.6.slim_kdump/arch/x86/kernel/cpu/mcheck/mce.c
> > > ===================================================================
> > > --- linux-2.6.slim_kdump.orig/arch/x86/kernel/cpu/mcheck/mce.c
> > > +++ linux-2.6.slim_kdump/arch/x86/kernel/cpu/mcheck/mce.c
> > > @@ -258,8 +258,7 @@ static void wait_for_panic(void)
> > >  	local_irq_enable();
> > >  	while (timeout-- > 0)
> > >  		udelay(1);
> > > -	xpanic(PANIC_NO_KEXEC|PANIC_NO_BACKTRACE, 0,
> > > -		"Panicing machine check CPU died");
> > > +	xpanic(PANIC_MCE, 0, NULL, 0, "Panicing machine check CPU died");
> > >  }
> > >  
> > >  static void mce_panic(char *msg, struct mce *final, char *exp)
> > > @@ -315,8 +314,8 @@ static void mce_panic(char *msg, struct
> > >  	if (exp)
> > >  		pr_emerg(HW_ERR "Machine check: %s\n", exp);
> > >  	if (!fake_panic) {
> > > -		xpanic(PANIC_NO_KEXEC|PANIC_NO_BACKTRACE, mce_panic_timeout,
> > > -			msg);
> > > +		xpanic(PANIC_MCE, mce_panic_timeout, final,
> > > +			sizeof(struct mce), msg);
> > >  	} else
> > >  		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
> > >  }
> > 
> > In previous patches you introduce PANIC_NO_KEXEC and PANIC_NO_BACKTRACE. 
> > Now in this patch you got rid of those. Are there any other users left
> > of PANIC_NO_BACKTRACE and PANIC_NO_EXEC? If not, then why to introduce
> > these to begin with.
> >
> 
> The previous patch also converts panic to xpanic and is taken from
> Andi's
> git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git tree.
> The changes are kept as two separate patches to identify their origin.

If you have to remove dead piece of code from original patch, I think
you can always take original patch, modify it and give the credit to
original author by explicitly mentioning it in your changelog.

Thanks
Vivek
