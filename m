Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1IURLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 13:11:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab1IURLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 13:11:14 -0400
Date: Wed, 21 Sep 2011 13:10:21 -0400
From: Don Zickus <dzickus@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, "x86@kernel.org" <x86@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V5][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110921171021.GV5795@redhat.com>
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
 <1316529792-6560-5-git-send-email-dzickus@redhat.com>
 <20110921100842.GA6063@erda.amd.com>
 <20110921140432.GP5795@redhat.com>
 <20110921151829.GC6063@erda.amd.com>
 <20110921161352.GU5795@redhat.com>
 <4E7A0FD6.3080508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7A0FD6.3080508@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 07:24:54PM +0300, Avi Kivity wrote:
> >>  But in rare cases there is the following:
> >>
> >>  1. The cpu executes some microcode or SMM code.
> >>  2. HW triggers the first NMI, an NMI is pending.
> >>  3. HW triggers a second NMI, the NMI is still pending.
> >>  4. The cpu finished microcode or SMM code.
> >>  5. NMI handler is called, no NMI pending anymore.
> >>  6. Return from NMI handler.
> >>
> >>  In this case the handler is called only once and the second nmi
> >>  remains unhandled with you implementation.
> >>
> >>  I don't see a way how this could be catched without serving all
> >>  handlers the first time. But as said, in favor of the optimization I
> >>  think we can live with losing some NMIs.
> >
> >Ah, I get it know.  Crap.  Well I think Avi was pushing it to make those
> >ticket_spin_locks work in virt land.  It seems like we should lean towards
> >removing the optimization.  Avi?
> >
> 
> Well, in virt land there are no SMIs, and we can guarantee that the
> queue length is always two.  So if these rare cases are okay for
> upstream, it'll be fine for virt.

Actually I was trying to remember what the argument for the optimization
was again?  I believe the virt team needed it right?

Cheers,
Don
