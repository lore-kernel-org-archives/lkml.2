Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1JJVNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 17:13:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58225 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab1JJVNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 17:13:51 -0400
Date: Mon, 10 Oct 2011 14:13:45 -0700
From: "tj@kernel.org" <tj@kernel.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
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
Subject: Re: [PATCH v2 0/3] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
Message-ID: <20111010211345.GL8100@google.com>
References: <Pine.LNX.4.44L0.1110101119550.18069-100000@netrider.rowland.org>
 <4E931018.8030904@linux.vnet.ibm.com>
 <20111010165343.GA29261@aftab>
 <4E932BBA.9090501@linux.vnet.ibm.com>
 <20111010175336.GA29415@aftab>
 <20111010180848.GI8100@google.com>
 <20111010183442.GC29415@aftab>
 <20111010185307.GK8100@google.com>
 <20111010202913.GA30798@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010202913.GA30798@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 10:29:13PM +0200, Borislav Petkov wrote:
> > Hmm... is it possible to tell whether the core coming online is the
> > same one as the last time?  If that's possible, the problem becomes
> > pretty simple and we can simply tell people who are mixing
> > suspend/hibernate with physical hotplug that they're crazy.
> 
> It is possible to compare ucode revisions of the core coming online and
> what we have in memory and do the update only if it is necessary. We
> still can keep the ucode image without the need for revalidation (and
> reloading).
> 
> Better?

Yeah yeah, I don't know how ucode is matched to specific CPU but just
store that identification of the last CPU and on ONLINE if it stays
the same, use the existing one.  If not, request new one.  It
shouldn't be difficult && solves the issue at hand while not breaking
hot-swap case.

Thanks.

-- 
tejun
