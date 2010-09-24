Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977Ab0IXQfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:35:08 -0400
Received: from kroah.org ([198.145.64.141]:37035 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932742Ab0IXQez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:34:55 -0400
Date: Fri, 24 Sep 2010 09:29:26 -0700
From: Greg KH <greg@kroah.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>, Greg KH <gregkh@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Erratum 383 fix for 32 bit x86 kernels
Message-ID: <20100924162926.GA7627@kroah.com>
References: <20100924115239.GA9817@amd.com>
 <20100924160205.GB21235@kroah.com>
 <20100924162433.GB7627@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100924162433.GB7627@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 06:24:34PM +0200, Borislav Petkov wrote:
> From: Greg KH <greg@kroah.com>
> Date: Fri, Sep 24, 2010 at 12:02:06PM -0400
> 
> > >  extern unsigned long setup_trampoline(void);
> > > +extern void __init setup_trampoline_page_table(void);
> > >  extern void __init reserve_trampoline_memory(void);
> > >  #else
> > >  static inline void reserve_trampoline_memory(void) {};
> > > +extern void __init setup_trampoline_page_table(void) {};
> > >  #endif /* CONFIG_X86_TRAMPOLINE */
> > 
> > I don't think that last setup_trampoline_page_table() line is correct
> > here.
> > 
> > Shouldn't it be:
> > 	static inline void setup_trampoline_page_table(void) {};
> > instead?
> > 
> > Otherwise I get the following error building the .32 code with this
> > patch:
> > 	  CC      arch/x86/kernel/setup.o
> > 	  arch/x86/kernel/setup.c: In function ‘setup_arch’:
> > 	  arch/x86/kernel/setup.c:1001:2: error: implicit declaration of function ‘setup_trampoline_page_table’
> > 
> > Is this really how the code looks upstream?
> > 
> > Hm, even with changing the function prototype, I still get an error
> > building on the .32-stable tree on x86-64, so I'm dropping this patch
> > from there.
> 
> Yeah, Joerg forgot 8848a91068c018bc91f597038a0f41462a0f88a4.
> 
> > Also, it didn't apply cleanly to .32-stable, I had to apply this chunk
> > by hand, no big deal.
> > 
> > So, why not I just take the original git commits that are in Linus's
> > tree?  That should work, right?  If so, do I just need to use those two
> > above-mentioned commits?  Or something else?  I prefer taking the
> > original commits as it makes spelunking over time much easier.
> 
> Sure, you need
> 
> 1. fd89a137924e0710078c3ae855e7cec1c43cb845	<-- erratum fix
> 2. 8848a91068c018bc91f597038a0f41462a0f88a4	<-- build fix
> 3. b7d460897739e02f186425b7276e3fdb1595cea7	<-- VMSPLIT_* fix
> 
> in that order and they should cherry-pick fine.
> 
> Let me know if you need something tested on our end.
> 
> Thanks and sorry for the confusion.

Ok, I'll do this for the next round of -stable kernel updates, this
arrived too late for the one that just went out for review right now.

thanks,

greg k-h
