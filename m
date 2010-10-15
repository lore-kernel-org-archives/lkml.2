Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab0JOAXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 20:23:08 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36420 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab0JOAXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 20:23:06 -0400
Date: Thu, 14 Oct 2010 17:23:00 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Michael Neuling <mikey@neuling.org>, Frans Pop <elendil@planet.nl>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>,
        Linas Vepstas <linasvepstas@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] ppc: don't override CONFIG_PPC_PSERIES_DEBUG
Message-ID: <20101015002300.GB7522@us.ibm.com>
References: <1287078495-11722-1-git-send-email-nacc@us.ibm.com>
 <1287101663.4194.5.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287101663.4194.5.camel@concordia>
X-Operating-System: Linux 2.6.35-22-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.10.2010 [11:14:23 +1100], Michael Ellerman wrote:
> On Thu, 2010-10-14 at 10:48 -0700, Nishanth Aravamudan wrote:
> > These files undef DEBUG, but I think they were added before the ability
> > to control this from Kconfig. 
> 
> Perhaps. Some people, *cough*, have a tendency to merge those back in
> again from time to time :)
> 
> > It's really annoying to only get some of the debug messages!
> 
> True, but ..
> 
> > Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> > 
> > ---
> > Because the lpar and pci_dlpar code is pretty low-level & verbose,
> > perhaps it makes sense to add another Kconfig variable for really
> > low-level stuff? But it's annoying to have DEBUG *somewhat* effective,
> > especially in the EEH area when doing PCI stuff.
> 
> I really don't think you want to enable the lpar debug by default.
> Have you tried it? It can make for a pretty unusable system, just
> because of the console spam.

Yeah, you're right. After enabling it, I had to kill my boot and start
over w/o the lpar DEBUG on. I assume dlpar_pci is similar?

I dunno, would a patch to a least remove the EEH one be ok? Seems like
it isn't super-verbose, and does have some handy output.

> Also these days there is CONFIG_DYNAMIC_DEBUG which is much smarter than
> all this, but requires setup at runtime.

True, I started looking into it, but only realized today that eeh.c had
that #undef! :)

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
