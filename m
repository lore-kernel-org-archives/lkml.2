Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab2HQTvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 15:51:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50021 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab2HQTuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 15:50:54 -0400
Date: Fri, 17 Aug 2012 20:50:34 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        preeti <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120817195033.GA15589@srcf.ucam.org>
References: <5028F12C.7080405@intel.com>
 <1345028738.31459.82.camel@twins>
 <502C98E8.20800@linux.vnet.ibm.com>
 <502CFD35.5000801@linux.intel.com>
 <20120817184100.GA13369@srcf.ucam.org>
 <502E90F3.2000702@linux.intel.com>
 <20120817184705.GB13369@srcf.ucam.org>
 <502E9F45.6030606@genband.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502E9F45.6030606@genband.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 01:45:09PM -0600, Chris Friesen wrote:
> On 08/17/2012 12:47 PM, Matthew Garrett wrote:

> The datasheet for the Xeon E5 (my variant at least) says it doesn't
> do C7 so never powers down the LLC.  However, as you said earlier
> once you can put the socket into C6 which saves about 30W compared
> to C1E.
> 
> So as far as I can see with this CPU at least you would benefit from
> shutting down a whole socket when possible.

Having any active cores on the system prevents all packages from going 
into PC6 or deeper. What I'm not clear on is whether less deep package C 
states are also blocked.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
