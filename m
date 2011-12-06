Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab1LFJAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:00:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48544 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab1LFJAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:00:22 -0500
X-Greylist: delayed 955 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Dec 2011 04:00:21 EST
Date: Tue, 6 Dec 2011 09:58:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Fenghua Yu <fenghua.yu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Message-ID: <20111206085816.GA11116@elte.hu>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
 <20111206084230.GC30062@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206084230.GC30062@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Secondly, and more importantly, is there *any* hardware in 
> existence that has a BIOS that can suspend/resume successfully 
> with BSP offlined? If such hardware exists then we need to 
> support it properly - initially perhaps by whitelisting such 
> systems.

I suspect the answer to that is 'no' - as resume is really just 
a fresh bootup of the physical CPU and BIOSen just start on the 
boot CPU, no questions asked.

So the right approach there would be to detect the case where we 
boot up back from S2RAM resume on an offlined CPU (the BSP is 
really just one of the possibilities - in theory a S2RAM resume 
could boot back up on any of the APs as well) - the resume code 
should move off that CPU ASAP and keep that CPU offlined.

But the hibernation angle should be considered. Hibernation 
already has to deal with the case where someone physically 
unplugs a CPU and then resumes from the disk image, right? How 
does the hibernation code handle that case currently?

Thanks,

	Ingo
