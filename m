Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1IUQy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:54:59 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:36635 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab1IUQy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:54:58 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2dK9371K1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRVTNI-01-HIC-02
X-M-MSG: 
Date: Wed, 21 Sep 2011 18:54:51 +0200
From: Robert Richter <robert.richter@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V5][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110921165451.GF6063@erda.amd.com>
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
 <1316529792-6560-5-git-send-email-dzickus@redhat.com>
 <20110921100842.GA6063@erda.amd.com>
 <20110921140432.GP5795@redhat.com>
 <20110921151829.GC6063@erda.amd.com>
 <20110921161352.GU5795@redhat.com>
 <4E7A0FD6.3080508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E7A0FD6.3080508@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.09.11 12:24:54, Avi Kivity wrote:
> On 09/21/2011 07:13 PM, Don Zickus wrote:
> > On Wed, Sep 21, 2011 at 05:18:30PM +0200, Robert Richter wrote:
> > >  On 21.09.11 10:04:32, Don Zickus wrote:

> > >  But in rare cases there is the following:
> > >
> > >  1. The cpu executes some microcode or SMM code.
> > >  2. HW triggers the first NMI, an NMI is pending.
> > >  3. HW triggers a second NMI, the NMI is still pending.
> > >  4. The cpu finished microcode or SMM code.
> > >  5. NMI handler is called, no NMI pending anymore.
> > >  6. Return from NMI handler.
> > >
> > >  In this case the handler is called only once and the second nmi
> > >  remains unhandled with you implementation.
> > >
> > >  I don't see a way how this could be catched without serving all
> > >  handlers the first time. But as said, in favor of the optimization I
> > >  think we can live with losing some NMIs.

I have to revise this after thinking more about this. We may not lose
an nmi for sources where the nmi handler must always reenable the nmi,
e.g. IBS. Losing one nmi means for IBS that sample generation gets
stuck.

-Robert

> >
> > Ah, I get it know.  Crap.  Well I think Avi was pushing it to make those
> > ticket_spin_locks work in virt land.  It seems like we should lean towards
> > removing the optimization.  Avi?
> >
> 
> Well, in virt land there are no SMIs, and we can guarantee that the 
> queue length is always two.  So if these rare cases are okay for 
> upstream, it'll be fine for virt.
> 
> -- 
> error compiling committee.c: too many arguments to function
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

