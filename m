Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab0KKVAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:00:00 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64323 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab0KKU77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:59:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UUJmhnlk3xcq7FfSMBJQwjdUaiKsATR6RMu9FYRDLWPSMg0HsQjpeeieyQVIByBbF/
         KV8aa9IfRMr7gvVkHWHQdu/gfI8aozj52EYlM9Qle4Y09ogOU6XRfjY4BGuR+NMfZ8lk
         8TgBSgBV69ecnaZr7kVOnBwbrVjLiitwfAwTY=
Date: Thu, 11 Nov 2010 23:59:55 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86, apic: Merge x2apic code
Message-ID: <20101111205955.GC6517@lenovo>
References: <20101110192053.GA6978@lenovo> <1289508257.2680.182.camel@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289508257.2680.182.camel@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 12:44:17PM -0800, Suresh Siddha wrote:
> On Wed, 2010-11-10 at 11:20 -0800, Cyrill Gorcunov wrote:
> > Hi, while being at x2apic_x.c code I noted that files look similar to
> > each other so I guessed may be we could merge them. As result --
> > this patch.
> 
> BTW, as you noticed, x2apic cluster mode allows IPI's to be sent to
> multiple cpu's (in the same cluster) at once. I was hoping sometime I
> will do this to see if it helps in anything.
> 
> So once we do that IPI code will look different.

yes, indeed, so enlight me a bit -- we have to map every cpu number from
cpumask to apic-id, then figure out if it belongs to same cluster, collect
such apic-ids and then send one ipi with one cluster and multiple apic-id
bits as a destination, or I miss something and there _can't_ ever be the
situation when first 16 cpus from cpumask belong to different clusters?

> 
> >  So comments/complains are appreciated and what is more important -- if we need
> > this patch at all.
> 
> May be we can do the merge for most of them but leave IPI code as it is
> (as that is also in the hot path). And may be while we are at this, we
> should probably look at the x2apic cluster IPI bits now aswell.
> 

yes, probably. Though I think first we need to resolve situation with
per-cluster IPIs.

> thanks,
> suresh
> 

 Cyrill
