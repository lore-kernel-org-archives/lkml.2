Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab0INFMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 01:12:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:8969 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab0INFMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 01:12:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,362,1280732400"; 
   d="scan'208";a="837398288"
Subject: Re: [RFC 4/6] x86, NMI, Rewrite NMI handler
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100913140419.GA27371@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	 <1284087065-32722-4-git-send-email-ying.huang@intel.com>
	 <20100910155605.GG4879@redhat.com>
	 <20100910180356.44ac7097@basil.nowhere.org>
	 <20100910182952.GJ4879@redhat.com>
	 <1284343770.3269.75.camel@yhuang-dev.sh.intel.com>
	 <20100913140419.GA27371@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 13:12:41 +0800
Message-ID: <1284441161.2256.94.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 22:04 +0800, Don Zickus wrote:
> On Mon, Sep 13, 2010 at 10:09:30AM +0800, Huang Ying wrote:
> > > The reason I asked was, I thought it would be easier to have a global
> > > variable that tells the nmi handler which cpu has the NMI's routed to its
> > > io port.  This way if you want to swap out the bsp cpu, you could perhaps
> > > just re-route the nmi to a new cpu and the global variable would be
> > > updated accordingly?
> > 
> > Then we need some kind of protection or race condition between
> > re-routing NMI and updating the variable. Do you think so?
> 
> Well, I thought the only reasonable place to update the variable is when
> the cpu is being taken offline, during the MTRR update.  Since no NMIs can
> be processed when the cpu's are syncing their MTRR, there shouldn't be a
> race condition, no?
> 
> Then again I am probably missing something obvious.  Like I don't know how
> cpu's deal with interrupts/NMIs when they are going offline.
> 
> It was just a thought to avoid the spinlock.

Why do you hate spinlock inside NMI handler? I think it is safe and
simple if only used in NMI handler.

Best Regards,
Huang Ying


