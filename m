Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463Ab1CDRpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:45:41 -0500
Received: from auth.codethink.co.uk ([208.78.96.188]:44698 "EHLO
	auth.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab1CDRpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:45:40 -0500
X-Greylist: delayed 3514 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 12:45:40 EST
Subject: Re: [PATCH] mcheck: Correction to a missing return value from
 misc_register
From: "J.P. Lacerda" <jpl@codethink.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johan Wessfeldt <johan.wessfeldt@gmail.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110302160601.a8936c21.akpm@linux-foundation.org>
References: <1298891944-21364-1-git-send-email-johan.wessfeldt@gmail.com>
	 <20110302160601.a8936c21.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 16:44:16 +0000
Message-ID: <1299257056.1964.13.camel@neoteric>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Where can a memory leak occur in sysdev_class_register()?
If one does occur, should the fix not be applied to
sysdev_class_register(), as opposed to mcheck_init_device()?

Thanks,

J.P.

On Wed, 2011-03-02 at 16:06 -0800, Andrew Morton wrote:
> On Mon, 28 Feb 2011 12:19:04 +0100
> Johan Wessfeldt <johan.wessfeldt@gmail.com> wrote:
> 
> > Return value from misc_register was not handled correctly
> > in mcheck_init_device()
> > 
> > Signed-off-by: Johan Wessfeldt <johan.wessfeldt@gmail.com>
> > ---
> >  arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> > index d916183..7274a11 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> > @@ -2140,7 +2140,7 @@ static __init int mcheck_init_device(void)
> >  	}
> >  
> >  	register_hotcpu_notifier(&mce_cpu_notifier);
> > -	misc_register(&mce_log_device);
> > +	err = misc_register(&mce_log_device);
> >  
> >  	return err;
> >  }
> 
> It should be fixed, but not that way.  If misc_register() fails here,
> mcheck_init_device() should undo all the things which it just did.
> 
> And the memory leak which occurs if sysdev_class_register() fails and
> the memory and other resource leaks which occur if mce_create_device()
> fails should be fixed too.
> 
> mcheck_init_device() a rather optimistic function.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


