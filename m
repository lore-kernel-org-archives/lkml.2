Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab0D3Rjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:39:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:28902 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758599Ab0D3Rja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:39:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,297,1270450800"; 
   d="scan'208";a="271686406"
Subject: Re: [PATCH RFC: linux-next 1/2] irq: Add CPU mask affinity hint
 callback framework
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1004292237280.2951@localhost.localdomain>
References: <20100419045741.30276.23233.stgit@ppwaskie-hc2.jf.intel.com>
	 <alpine.LFD.2.00.1004271425140.2951@localhost.localdomain>
	 <Pine.WNT.4.64.1004270856560.320@PPWASKIE-MOBL2.amr.corp.intel.com>
	 <alpine.LFD.2.00.1004271809080.2951@localhost.localdomain>
	 <1272563946.9614.1.camel@localhost>
	 <alpine.LFD.2.00.1004292121310.2951@localhost.localdomain>
	 <1272572930.9614.3.camel@localhost>
	 <alpine.LFD.2.00.1004292237280.2951@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Apr 2010 14:29:10 -0700
Message-ID: <1272576550.9614.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-29 at 13:39 -0700, Thomas Gleixner wrote:
> On Thu, 29 Apr 2010, Peter P Waskiewicz Jr wrote:
> > On Thu, 2010-04-29 at 12:48 -0700, Thomas Gleixner wrote:
> > > Thinking more about it, I wonder whether you have a cpu_mask in your
> > > driver/device private data anyway. I bet you have :)
> > 
> > Well, at this point we don't, but nothing says we can't.
> 
> Somewhere you need to store that information in your driver, right ?

Yes.  But right now, storing a cpu_mask for an interrupt wouldn't buy us
anything since we have no mechanism to make use of it today.  :-)

I'll be putting the cpu_mask entry in our q_vector structure, which is
our abstraction of the MSI-X vector (it's where I have the hint struct
right now in patch 2/2 for the ixgbe driver).  It's a simple place to
stick it.

> > > So it should be sufficient to set a pointer to that cpu_mask in
> > > irq_desc and get rid of the callback completely.
> > 
> > So "register" would just assign the pointer, and "unregister" would make
> > sure to NULL the mask pointer out.  I like it.  It'll sure clean things
> > up too.
> 
> Yep, that'd be like the set_irq_chip() function. Just assign the
> pointer under desc->lock.
> 
> Thanks,
> 
> 	tglx


