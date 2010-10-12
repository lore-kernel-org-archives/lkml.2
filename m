Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab0JLBKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 21:10:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:30216 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658Ab0JLBKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 21:10:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,317,1283756400"; 
   d="scan'208";a="562980268"
Subject: Re: [PATCH -v3 5/6] x86, NMI, treat unknown NMI as hardware error
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <20101011212006.GB23882@redhat.com>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
	 <1286606987-19879-5-git-send-email-ying.huang@intel.com>
	 <20101011212006.GB23882@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 09:10:21 +0800
Message-ID: <1286845821.7768.150.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 05:20 +0800, Don Zickus wrote:
> On Sat, Oct 09, 2010 at 02:49:46PM +0800, Huang Ying wrote:
> > In general, unknown NMI is used by hardware and firmware to notify
> > fatal hardware errors to OS. So the Linux should treat unknown NMI as
> > hardware error and go panic upon unknown NMI for better error
> > containment.
> > 
> > But there are some broken hardware, which will generate unknown NMI
> > not for hardware error. To support these machines, a white list
> > mechanism is provided to treat unknown NMI as hardware error only on
> > some known working system.
> > 
> > These systems are identified via the presentation of APEI HEST or
> > some PCI ID of the host bridge. The PCI ID of host bridge instead of
> > DMI ID is used, so that the checking can be done based on the platform
> > type instead of motherboard. This should be simpler and sufficient.
> > 
> > The method to identify the platforms is designed by Andi Kleen.
> 
> I don't have any major problems with the other patches in the patch
> series.  In fact I would like to get them committed somewhere, so we can
> continue building on them.

Thanks.

> > @@ -366,6 +368,15 @@ unknown_nmi_error(unsigned char reason,
> >  	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
> >  			NOTIFY_STOP)
> >  		return;
> > +	/*
> > +	 * On some platforms, hardware errors may be notified via
> > +	 * unknown NMI
> > +	 */
> > +	if (unknown_nmi_as_hwerr)
> > +		panic(
> > +		"NMI for hardware error without error record: Not continuing\n"
> > +		"Please check BIOS/BMC log for further information.");
> > +
> >  #ifdef CONFIG_MCA
> >  	/*
> >  	 * Might actually be able to figure out what the guilty party
> 
> The only quirk I have left is the above piece, which is basically a
> philosophy difference with Robert and myself.  Where we believe it should
> be on the die_chain and Andi and yourself would like to see it explicitly
> called out.
> 
> If we move to a new notifier chain, like we discussed in another thread,
> would you guys be willing to move this into that new notifier chain or is
> your argument still going to stand?

Perhaps I will not move this into that new notifier chain. If you want
to do that, feel free to pick it up and change it as you will.

Best Regards,
Huang Ying


