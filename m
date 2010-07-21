Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab0GUQwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 12:52:22 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60299 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab0GUQwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 12:52:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BdHS7tMq1IXIkGGdol2A/0ak+JiQyIS6VaawAcLq63qIT8ltvhccWaTktBC3SyX85F
         dQFOzKHocWlEdrogO4OepwCJYHhSLxeIXrHESUQLs57KgFmOAik4/mdfQ19cf6LzaZQk
         UcamcvBDNnEYx5gAe8tWzdYJl7cHLxxTmyLAM=
Date: Wed, 21 Jul 2010 20:52:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] x86, xsave: some code cleanups and reworks
Message-ID: <20100721165211.GD8009@lenovo>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com> <20100720192717.GC6227@lenovo> <20100720194606.GO26154@erda.amd.com> <20100720200729.GD6227@lenovo> <20100720201740.GE6227@lenovo> <4C472123.1090900@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C472123.1090900@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 09:32:35AM -0700, H. Peter Anvin wrote:
> On 07/20/2010 01:17 PM, Cyrill Gorcunov wrote:
> > 
> > well, not true, this id is being set in setup_per_cpu_areas()
> > note the snippet
> > 
> > 		if (cpu == boot_cpu_id)
> > 			switch_to_new_gdt(cpu);
> > 
> > but cycle of assignment is done over all possible cpus so
> > smp_processor_id will be = 0 for BP but definitely it's
> > confusing and better to check for BP via explicit cpu == boot_cpu_id
> > I think. Though I might be missing something.
> > 
> 
> I think the style (!smp_processor_id()) is already in use in other
> places, but we should be consistent in style; if you want to introduce a
> new style I certainly agree that (is_boot_cpu()) is pretty clear but it
> should be introduced universally.
> 
> 	-hpa
>

yes, also I bet there will be places with patterns like

	cpu = smp_processor_id();
	if (!cpu)
	 or
	if (cpu == 0)

so every single smp_processor_id and "raw" version as well should be
checked. I'll take a look as only get ability. If Robert (or anyone)
will like to beat me on this -- I would be only glad ;)

	-- Cyrill
