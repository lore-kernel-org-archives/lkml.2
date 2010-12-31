Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0LaNUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 08:20:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54841 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab0LaNUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 08:20:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C27orYdAXRs0bBMXqyS0W/Qd6uPAbS/wM7JZAstE6SGZcfRX05To12N5WSLW411y3v
         8geKjstVsxB7Bf7Hmz3bcz5zqCCCO9JEsEuWhPokLCTAUB/ZEyNPKzHzuAHcmoKoqtnI
         sS4VCqn3V/kVGDZDmMN9nb9btJZFjY60wu06Y=
Date: Fri, 31 Dec 2010 14:20:34 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, Pekka Enberg <penberg@kernel.org>,
        shaohui.zheng@intel.com
Subject: Re: [PATCH 15/16] x86: Unify node_to_cpumask_map handling between
 32 and 64bit
Message-ID: <20101231132034.GK18831@htj.dyndns.org>
References: <1293536929-31683-1-git-send-email-tj@kernel.org>
 <1293536929-31683-16-git-send-email-tj@kernel.org>
 <alpine.DEB.2.00.1012281240000.8883@chino.kir.corp.google.com>
 <20101230124800.GD18831@htj.dyndns.org>
 <20101230145858.GE18831@htj.dyndns.org>
 <alpine.DEB.2.00.1012301028590.12207@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012301028590.12207@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 30, 2010 at 10:40:33AM -0800, David Rientjes wrote:
> On Thu, 30 Dec 2010, Tejun Heo wrote:
> 
> > > Sigh, the new NUMA emulation thing is 64bit only. :-( I'll see if it
> > > can be applied to 32bit too.  BTW, how does this interact with the
> > > Shaohui's patchset.  Isn't that about NUMA emulation too?  Are these
> > > the same patches?
> 
> Shaohui's patchset is for node hotplug emulation, not for NUMA emulation 
> which has existed for x86_64 for at least over four years.

I see.  Yeah, I should have actually read the patchset before talking
about it.

> I agree that unification is in our best interest but the patches as they 
> sit in x86/numa right now actually fix real bugs when using numa=fake on 
> the command line and adding i386 NUMA emulation is an additional feature 

I'm not really arguing against you and as said before the patches were
fine given the current state of the code, but I still want to point
out that it's through these mostly innocent series of changes which
build upon existing complications which eventually lead to
unsustainable pile of mess.  No one is particularly wrong but then
again none does what really needs to be done.

> (and the unification that can be done in the meantime would only be the 
> actual apicid-to-node and pxm-to-node mappings after it is exported from 
> amd and acpi specific functions), so I'd prefer to handle cleanups as 
> incremental patches on top of those.

The problem is that those "incremental" patches often don't happen
once the itch is gone while the immediate fixes/improvements aggravate
existing complications.  If you were/are planning to clean it up, I
have nothing to whine about.  :-)

Thanks.

-- 
tejun
