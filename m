Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1IUQFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:05:16 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:15980 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab1IUQFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:05:15 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LRVRB2-01-CTU-02
X-M-MSG: 
Date: Wed, 21 Sep 2011 18:04:09 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V5][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110921160409.GE6063@erda.amd.com>
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
 <1316529792-6560-5-git-send-email-dzickus@redhat.com>
 <20110921100842.GA6063@erda.amd.com>
 <20110921140432.GP5795@redhat.com>
 <20110921151829.GC6063@erda.amd.com>
 <1316619232.24750.2.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316619232.24750.2.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.09.11 11:33:52, Peter Zijlstra wrote:
> On Wed, 2011-09-21 at 17:18 +0200, Robert Richter wrote:
> > 1. The cpu executes some microcode or SMM code.
> > 2. HW triggers the first NMI, an NMI is pending.
> > 3. HW triggers a second NMI, the NMI is still pending.
> > 4. The cpu finished microcode or SMM code.
> > 5. NMI handler is called, no NMI pending anymore.
> > 6. Return from NMI handler. 
> 
> Even without SMM, all you need is two different NMI users to trigger
> while an NMI is in flight.
> 
> Wouldn't be entirely impossible to trigger if you have
> non-fatal-MCE/hardware-NMI-switch/PMI all active.

No, I am trying to explain this...

If hw triggers more than one nmi *before* the nmi handler is entered
(no matter what the source is), then there will be no back-to-back
nmi. NMIs are edge triggered and there is only one pending signal (AMD
cpus). The signal is cleared when entering the handler. If the cpu
executes microcode or smm code and delays execution of the nmi
handler, then there is no second call of the handler even if there are
2 sources for it.

-Robert


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

