Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab1JAKRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 06:17:00 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56745 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756406Ab1JAKQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 06:16:38 -0400
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
From: Matt Fleming <matt@console-pimps.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20110930235625.GD2658@mtj.dyndns.org>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
	 <20110930165206.GA22048@redhat.com>
	 <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20110930235625.GD2658@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 01 Oct 2011 11:16:32 +0100
Message-ID: <1317464192.3375.57.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 16:56 -0700, Tejun Heo wrote:
> Hello,
> 
> On Fri, Sep 30, 2011 at 09:00:23PM +0100, Matt Fleming wrote:
> > On Fri, 2011-09-30 at 18:52 +0200, Oleg Nesterov wrote:
> > Well, sighand->siglock is seriously overused. It protects so much and I
> > think it's pretty confusing. It took me long enough to figure out how
> > many locks were really needed. But that's beside the point, having a
> > single lock doesn't scale at all, and that's what this series is about.
> 
> But scalability for what?  What are the use cases here?  Do we care
> enough about benefits to those use cases to accept the increased
> complexity?  Having locks with broad coverage isn't necessarily evil.
> If things are simpler that way and the protected paths aren't that
> hot, who cares?  If splitting the locking makes things simpler, sure
> but that doesn't look like the case here, so we need pretty strong
> rationale to justify the added complexity.

I've Cc'd some -rt folks who have mentioned this bottleneck in the past.

This patch series improves signal delivery scalability. Signals are
still used heavily in legacy rt applications (as I'm hoping the -rt
folks will attest to) and because everything is currently serialiesd
with the per-process siglock, any heavy usage quickly hits that
bottleneck. It's essentially a big-lock for signal delivery within a
process.

I also think Thomas/Peter mentioned something about latency in
delivering timer signals because of contention on the per-process
siglock. They might have some more details on that.

-- 
Matt Fleming, Intel Open Source Technology Center

