Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2HOQXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:23:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41427 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2HOQXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:23:35 -0400
Date: Wed, 15 Aug 2012 17:23:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alex Shi <alex.shi@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120815162328.GB14534@srcf.ucam.org>
References: <5028F12C.7080405@intel.com>
 <1345028738.31459.82.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345028738.31459.82.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 01:05:38PM +0200, Peter Zijlstra wrote:

> Yay, ideally we'd also provide a 3rd option: auto, which simply switches
> between the two based on AC/BAT, UPS status and simple things like that.

Please, really, don't do that. Pushing power policy decisions into 
multiple bits of the stack makes things much more awkward, especially 
when the criteria you're describing are about the least interesting 
reasons for switching these states. They're most relevant on 
multi-socket systems, and the overwhelming power concern there is 
rack-level overcommit or cooling. You're going to need an external 
policy agent to handle the majority of cases people actually care about.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
