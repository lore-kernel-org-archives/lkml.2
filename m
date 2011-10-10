Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1JJQ6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:58:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56186 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab1JJQ57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:57:59 -0400
Date: Mon, 10 Oct 2011 09:57:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, rjw@sisk.pl,
        bp@amd64.org, pavel@ucw.cz, len.brown@intel.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, lucas.demarchi@profusion.mobi,
        rusty@rustcorp.com.au, rdunlap@xenotime.net, vatsa@linux.vnet.ibm.com,
        ashok.raj@intel.com, tigran@aivazian.fsnet.co.uk, tglx@linutronix.de,
        hpa@zytor.com, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
Message-ID: <20111010165754.GC8100@google.com>
References: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com>
 <Pine.LNX.4.44L0.1110101119550.18069-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1110101119550.18069-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

On Mon, Oct 10, 2011 at 11:23:13AM -0400, Alan Stern wrote:
> Furthermore, if the entire problem is lack of CPU microcode, hasn't 
> that been fixed already?  There recently was a patch to avoid releasing 
> microcode after it was first loaded -- the idea being that there would 
> then be no need to get the microcode from userspace again at awkward 
> times while the system is resuming.

It's a deadlock problem.  Currently, the code allows actual CPU
hotplug (which naturally requires loading microcode using userland
helper) and system suspend to race.  CPU hotplug won't be able to make
progress as microcode can't be loaded due to on-going freezing and
system suspend will eventually time out waiting for CPU hotplug to
finish.  The two operations need to be serialized.

Or are you arguing that initiating CPU hotplug operation while system
suspend is in progress is user error and we don't need to worry about
this?  Maybe that isn't such a bad idea either.

Thanks.

-- 
tejun
