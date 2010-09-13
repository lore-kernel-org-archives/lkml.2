Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0IMOEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:04:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab0IMOEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:04:42 -0400
Date: Mon, 13 Sep 2010 10:04:19 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 4/6] x86, NMI, Rewrite NMI handler
Message-ID: <20100913140419.GA27371@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284087065-32722-4-git-send-email-ying.huang@intel.com>
 <20100910155605.GG4879@redhat.com>
 <20100910180356.44ac7097@basil.nowhere.org>
 <20100910182952.GJ4879@redhat.com>
 <1284343770.3269.75.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284343770.3269.75.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 10:09:30AM +0800, Huang Ying wrote:
> > The reason I asked was, I thought it would be easier to have a global
> > variable that tells the nmi handler which cpu has the NMI's routed to its
> > io port.  This way if you want to swap out the bsp cpu, you could perhaps
> > just re-route the nmi to a new cpu and the global variable would be
> > updated accordingly?
> 
> Then we need some kind of protection or race condition between
> re-routing NMI and updating the variable. Do you think so?

Well, I thought the only reasonable place to update the variable is when
the cpu is being taken offline, during the MTRR update.  Since no NMIs can
be processed when the cpu's are syncing their MTRR, there shouldn't be a
race condition, no?

Then again I am probably missing something obvious.  Like I don't know how
cpu's deal with interrupts/NMIs when they are going offline.

It was just a thought to avoid the spinlock.

Cheers,
Don
