Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab2HTSRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:17:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54442 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2HTSRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:17:08 -0400
Date: Mon, 20 Aug 2012 19:16:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120820181651.GA737@srcf.ucam.org>
References: <5028F12C.7080405@intel.com>
 <1345028738.31459.82.camel@twins>
 <502BA7DC.7060907@linux.intel.com>
 <1345041548.31459.90.camel@twins>
 <502BB5A3.5000403@linux.intel.com>
 <1345043096.31459.106.camel@twins>
 <502BE38D.9030405@linux.intel.com>
 <20120820080606.GA6931@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820080606.GA6931@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 10:06:06AM +0200, Ingo Molnar wrote:

> If the answer is 'yes' then there's clear cases where the kernel 
> (should) automatically know the events where we switch from 
> balancing for performance to balancing for power:

No. We can't identify all of these cases and we can't identify corner 
cases. Putting this kind of policy in the kernel is an awful idea. It 
should never be altering policy itself, because it'll get it wrong and 
people will file bugs complaining that it got it wrong and the biggest 
case where you *need* to be able to handle switching between performance 
and power optimisations (your rack management unit just told you that 
you're going to have to drop power consumption by 20W) is one where the 
kernel doesn't have all the information it needs to do this. So why 
bother at all?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
