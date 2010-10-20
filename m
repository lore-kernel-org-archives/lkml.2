Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab0JTGMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:12:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:30870 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179Ab0JTGMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:12:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,354,1283756400"; 
   d="scan'208";a="848987929"
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
Date: Wed, 20 Oct 2010 14:12:37 +0800
Message-ID: <1287555157.3026.21.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Don,

On Tue, 2010-10-12 at 05:20 +0800, Don Zickus wrote:
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

After some more thought, I found this is different from DIE_NMI and
DIE_NMI_IPI case. I think the code added is for general unknown NMI
processing instead of a device driver. What we do is not to add special
processing for some devices, but treat unknown NMI as hardware error
notification in general and use a white list to deal with broken
hardware and stone age machine. Do you agree?

If so, it should not be turned into a notifier block unless you want to
turn all general unknown NMI processing code into a notifier block.

Best Regards,
Huang Ying


