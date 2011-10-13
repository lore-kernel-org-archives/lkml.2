Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab1JMSDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:03:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59379 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755241Ab1JMSDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:03:45 -0400
Date: Thu, 13 Oct 2011 14:03:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Borislav Petkov <bp@amd64.org>
cc: Tejun Heo <tj@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "vatsa@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] Mutually exclude cpu online and suspend/hibernate
In-Reply-To: <20111013170153.GB3064@aftab>
Message-ID: <Pine.LNX.4.44L0.1110131400000.2026-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Borislav Petkov wrote:

> On Thu, Oct 13, 2011 at 12:06:02PM -0400, Tejun Heo wrote:
> > I hate to sound like a broken recorder but the above patch isn't
> > strictly correct for hot-swap cases, right?
> 
> hpa is working on a ucode loading solution which will take care of your
> hotswap case too.

You know, it would be a good idea to take a step back and think about a 
broader picture.  Suspend and hibernate need to be mutually exclusive 
with other things as well.  The two examples which people have been 
talking about are firmware updates (if the computer goes to sleep 
while the firmware is being changed, it ends up as a brick) and battery 
recharging (the CPU needs to respond quickly to temperature and charger 
events).

There ought to be a general-purpose "prevent system sleep" mechanism 
usable both from within the kernel and from userspace.

Alan Stern

