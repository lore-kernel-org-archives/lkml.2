Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab0GURBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:01:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35332 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab0GURB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:01:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pTGptz2cPfOwlQZJmNudc4JJ3gnP7BVdxVjaZ19DnGuAYfuGCJjT5LNa5MAUjMDVFT
         FW/mgG9wbwBg0lnbHoduWIyuKf4jrD9QikMtRFHAIrUXvDmr7JbtIXz/NAGsOxAIXEzu
         U2KCwbAb/4VckugfXaqG/swdmdszDnm/+nt88=
Date: Wed, 21 Jul 2010 21:01:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] x86, xsave: some code cleanups and reworks
Message-ID: <20100721170124.GE8009@lenovo>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com> <20100720192717.GC6227@lenovo> <20100720194606.GO26154@erda.amd.com> <20100720200729.GD6227@lenovo> <20100720201740.GE6227@lenovo> <4C472123.1090900@zytor.com> <20100721165211.GD8009@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721165211.GD8009@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 08:52:11PM +0400, Cyrill Gorcunov wrote:
> On Wed, Jul 21, 2010 at 09:32:35AM -0700, H. Peter Anvin wrote:
> > On 07/20/2010 01:17 PM, Cyrill Gorcunov wrote:
> > > 
> > > well, not true, this id is being set in setup_per_cpu_areas()
> > > note the snippet
> > > 
> > > 		if (cpu == boot_cpu_id)
> > > 			switch_to_new_gdt(cpu);
> > > 
> > > but cycle of assignment is done over all possible cpus so
> > > smp_processor_id will be = 0 for BP but definitely it's
> > > confusing and better to check for BP via explicit cpu == boot_cpu_id
> > > I think. Though I might be missing something.
> > > 
> > 
> > I think the style (!smp_processor_id()) is already in use in other
> > places, but we should be consistent in style; if you want to introduce a
> > new style I certainly agree that (is_boot_cpu()) is pretty clear but it
> > should be introduced universally.
> > 
> > 	-hpa
> >
> 

Peter, also I think such tuning must be done at merge window time only,
just to not break other's patch queues.

	-- Cyrill
