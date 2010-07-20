Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab0GTURq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:17:46 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47207 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759100Ab0GTURm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:17:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CTfE/c8F7weik+lOcb1QjII8QalvhKJoC8zRuvzDq0gUyeyDcsl/rDyXht8U0DbLaj
         ETnt5CbTZTNh7m1wrdovJQcAb6AiIS2UL7PMEgyjrwwbw+7ZOce394lH9oAGQGhF3xhX
         g2lYqP6ZnS/HX7awqaalx8g3SsmvGV0Q9Si3w=
Date: Wed, 21 Jul 2010 00:17:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] x86, xsave: some code cleanups and reworks
Message-ID: <20100720201740.GE6227@lenovo>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com> <20100720192717.GC6227@lenovo> <20100720194606.GO26154@erda.amd.com> <20100720200729.GD6227@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100720200729.GD6227@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 12:07:29AM +0400, Cyrill Gorcunov wrote:
...
> > 
> > But first question is, is it always !smp_processor_id()? At least
> > current implementation indicates this:
> > 
> 
> I guess so, since it's assigned from boot_cpu_id iirc
> 

well, not true, this id is being set in setup_per_cpu_areas()
note the snippet

		if (cpu == boot_cpu_id)
			switch_to_new_gdt(cpu);

but cycle of assignment is done over all possible cpus so
smp_processor_id will be = 0 for BP but definitely it's
confusing and better to check for BP via explicit cpu == boot_cpu_id
I think. Though I might be missing something.

> >  void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
> >  {
> >  	BUG_ON(c == &boot_cpu_data);
> >  	...
> > 
> > with:
> > 
> >  #define boot_cpu_data cpu_data[0]
> > 
> > ... which is valid for 32 and 64 bit.
> >
 
	-- Cyrill
