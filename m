Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0IMCJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 22:09:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:19058 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab0IMCJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 22:09:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,357,1280732400"; 
   d="scan'208";a="837061019"
Subject: Re: [RFC 4/6] x86, NMI, Rewrite NMI handler
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100910182952.GJ4879@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	 <1284087065-32722-4-git-send-email-ying.huang@intel.com>
	 <20100910155605.GG4879@redhat.com>
	 <20100910180356.44ac7097@basil.nowhere.org>
	 <20100910182952.GJ4879@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 10:09:30 +0800
Message-ID: <1284343770.3269.75.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 02:29 +0800, Don Zickus wrote:
> On Fri, Sep 10, 2010 at 06:03:56PM +0200, Andi Kleen wrote:
> > On Fri, 10 Sep 2010 11:56:05 -0400
> > Don Zickus <dzickus@redhat.com> wrote:
> > 
> > > On Fri, Sep 10, 2010 at 10:51:03AM +0800, Huang Ying wrote:
> > > > The original NMI handler is quite outdated in many aspects. This
> > > > patch try to fix it.
> > > > 
> > > > In original code, NMI reason io port (0x61) is only processed on
> > > > BSP. This makes it impossible to hot-remove BSP. To solve the issue,
> > > > a raw spinlock is used to make the port can be processed on any CPU.
> > > 
> > > Do we really want to use a spinlock inside the nmi handler?
> > 
> > As long as it's only between CPUs
> > (that is only ever used between different NMI handlers) 
> > that's fine.  It's certainly safer than having races between CPUs.
> > 
> > > I thought the NMIs sent to the io port are only routed to one cpu as
> > > determined by the io-apic?  Is it spread out to other cpus now?
> > 
> > There can be cases where it can happen I believe.
> 
> The reason I asked was, I thought it would be easier to have a global
> variable that tells the nmi handler which cpu has the NMI's routed to its
> io port.  This way if you want to swap out the bsp cpu, you could perhaps
> just re-route the nmi to a new cpu and the global variable would be
> updated accordingly?

Then we need some kind of protection or race condition between
re-routing NMI and updating the variable. Do you think so?

Best Regards,
Huang Ying 

