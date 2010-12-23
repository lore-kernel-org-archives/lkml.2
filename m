Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab0LWVI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 16:08:59 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:49055 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751418Ab0LWVI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 16:08:56 -0500
Date: Thu, 23 Dec 2010 21:48:21 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Matthew Garrett <mjg@redhat.com>, Youquan Song <youquan.song@intel.com>,
        davej@redhat.com, cpufreq@vger.kernel.org, arjan@linux.intel.com,
        lenb@kernel.org, suresh.b.siddha@intel.com, kent.liu@intel.com,
        chaohong.guo@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 6/6] cpufreq: Evaluate P1 before enter turbo mode
Message-ID: <20101223204821.GA6441@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Venkatesh Pallipadi <venki@google.com>,
	Matthew Garrett <mjg@redhat.com>,
	Youquan Song <youquan.song@intel.com>, davej@redhat.com,
	cpufreq@vger.kernel.org, arjan@linux.intel.com, lenb@kernel.org,
	suresh.b.siddha@intel.com, kent.liu@intel.com,
	chaohong.guo@intel.com, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	Youquan Song <youquan.song@linux.intel.com>
References: <1293085424-18212-1-git-send-email-youquan.song@intel.com>
 <1293085424-18212-2-git-send-email-youquan.song@intel.com>
 <1293085424-18212-3-git-send-email-youquan.song@intel.com>
 <1293085424-18212-4-git-send-email-youquan.song@intel.com>
 <1293085424-18212-5-git-send-email-youquan.song@intel.com>
 <1293085424-18212-6-git-send-email-youquan.song@intel.com>
 <1293085424-18212-7-git-send-email-youquan.song@intel.com>
 <20101223105730.GB18363@comet.dominikbrodowski.net>
 <20101223143859.GA1402@srcf.ucam.org>
 <AANLkTi=XkMqUSfO076mVqGCHv-Kw-jnuL8dZiN17ypqZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=XkMqUSfO076mVqGCHv-Kw-jnuL8dZiN17ypqZ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Dec 23, 2010 at 10:13:54AM -0800, Venkatesh Pallipadi wrote:
> On Thu, Dec 23, 2010 at 6:38 AM, Matthew Garrett <mjg@redhat.com> wrote:
> > On Thu, Dec 23, 2010 at 11:57:30AM +0100, Dominik Brodowski wrote:
> >
> >> NACK. First of all, why is it only a "turbo mode" if it's 1000 kHz
> >> difference?
> >
> > I believe that that's how it's supposed to be defined for Intel systems,
> > but you're right that this doesn't belong in generic code. AMD have
> > support for enabling/disabling their equivalent functionality through
> > sysfs - I'd say that copying that interface and using it to limit the
> > set of p-states provided to the core makes more sense.
> >
> 
> If this 1000kHz hack is needed, it should be in acpi-cpufreq driver
> along with Intel CPU and Turbo mode capability check..
> I had a change earlier and I don't think I ever pushed it out. But, it
> was doing the max freq transition on turbo capable CPUs in 2 steps.
> Something like:
> - cpu is in one of the low freqs.
> - ondemand asks for highest freq.
> - acpi-cpufreq will check whether the CPU is turbo capable and will
> only switch to non-turbo peak freq as first step.
> - If ondemand asks for highest freq again, acpi-cpufreq will then
> switch to turbo freq.
> 
> Something like that would probably help the problem here?

then we'd put policy in two places, instead of letting the decision be made
at one place. So I'd not favour such an approach... What should indeed be in
acpi-cpufreq is to mark certain frequency steps as being not power
efficient, though.

Best,
	Dominik
