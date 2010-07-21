Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761230Ab0GURha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:37:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39387 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab0GURh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rnQQ7IF5IguevLqJhMNLE+0OEqzvIkE8mtFGejddfZky+nMMBZAxL407kdoPVlhGT6
         vCifm8hU4fczBt5XOjUiICesFeLl0fwA/tnbF3nNMB1srHTwQDUq6Jw7pelmpXzmA80O
         3z7wJcN9PVkDddsHLfM6AdnQHn1VuXQnE4h0I=
Date: Wed, 21 Jul 2010 21:37:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] x86, xsave: some code cleanups and reworks
Message-ID: <20100721173723.GG8009@lenovo>
References: <20100720192717.GC6227@lenovo> <20100720194606.GO26154@erda.amd.com> <20100720200729.GD6227@lenovo> <20100720201740.GE6227@lenovo> <4C472123.1090900@zytor.com> <20100721165211.GD8009@lenovo> <20100721170124.GE8009@lenovo> <4C472A5C.50004@zytor.com> <20100721171718.GF8009@lenovo> <20100721172428.GS26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721172428.GS26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 07:24:28PM +0200, Robert Richter wrote:
> On 21.07.10 13:17:18, Cyrill Gorcunov wrote:
> > On Wed, Jul 21, 2010 at 10:11:56AM -0700, H. Peter Anvin wrote:
> > > On 07/21/2010 10:01 AM, Cyrill Gorcunov wrote:
> > > > 
> > > > Peter, also I think such tuning must be done at merge window time only,
> > > > just to not break other's patch queues.
> > > > 
> > > 
> > > Realistically it should be done right after the merge window for the
> > > *next* merge window.
> > > 
> > > 	-hpa
> > >
> > 
> > ok, which means Robert should use old conventional test at the moment
> > instead of introducing is_boot_cpu I suppose.
> 
> Yes, I am just using:
> 
> if (!smp_processor_id())
> 	...

ok, I see

> 
> Cyrill, if you like, I will leave it up to you to introduce the
> is_boot_cpu() macro.

ok Robert, I may handle it, notes below

> 
> I still have patch 7/7 in my new posting in that removes the
> boot_cpu_id. If your patch comes soon this will be obsolete as all
> places will have the macro then.
> 

I guess I can make it in a hour or so (since need to check all possible
places) but it might break other's queue I fear. That is why hpa noted
such things should go after merge window.

So I don't know Robert what would be preferred. If Peter pick up your
patch for now -- I may just keep it somewhere localy to not loose the traces of
boot_cpu_id and use this patch as helper. I just fear I can forget
about this promise to introduce is_boot_cpu helper later ;)

Another option could be -- introduce it now and send to trivial@ ML
so it'll be picked up there and pushed upstream after merge window.

> Thanks,
> 
> -Robert
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> 
	-- Cyrill
