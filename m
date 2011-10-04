Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab1JDHPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 03:15:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43598 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab1JDHPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 03:15:12 -0400
Date: Tue, 4 Oct 2011 00:15:08 -0700
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, tigran@aivazian.fsnet.co.uk,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
Message-ID: <20111004071508.GA15637@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4E88B5E0.6080503@linux.vnet.ibm.com>
 <20111002195023.GC31799@mtj.dyndns.org>
 <4E88C3D4.2020300@linux.vnet.ibm.com>
 <20111003004051.GD31799@mtj.dyndns.org>
 <4E894D75.808@linux.vnet.ibm.com>
 <20111003084754.GB4411@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003084754.GB4411@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 03, 2011 at 10:47:54AM +0200, Borislav Petkov wrote:
> I think your patch makes sense because re-loading the ucode during
> a suspend/resume cycle is unnecessary. If one wants to update the
> microcode, it should happen later when the box is resumed again: you
> simply put the new microcode image in /lib/firmware/... and on AMD
> unload/reload the microcode module and on Intel you do either that or
> use the deprecated microcode_ctl.

I don't think it changes anything for suspend/resume cycles.  They're
different hooks.  The proposed patch changes actual cpu hotplug paths.

> However, let me test it on a couple of AMD boxes tomorrow to verify.
> 
> > At the moment I can't think of any clean solution that solves both these problems - 
> >   a. The problem of requesting microcode from userspace when it is frozen (which can be individually
> >      solved by my patch).
> >   b. The possible need for a revised microcode during CPU online (due to the remote usecase of 
> >      physically plugging-out and plugging-in a new CPU), when the tasks are frozen.
> 
> Yeah, let me remind you guys, we're talking about x86 CPUs here. AFAICT,
> I don't think that physical unplug is supported by any vendor yet but
> I'd welcome surprises :-).

I recall hearing about someone experimenting with actual hotplug a
while ago.  Dunno whether that was production or not tho.  Even if
not, given the continuing penetration of x86 into highend, I don't
think it would take too long to see physical CPU hotplug in
production.  Also, it just is a poor engineering.

Thanks.

--
tejun
