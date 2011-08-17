Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab1HQJ5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 05:57:05 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55551 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752413Ab1HQJ5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 05:57:02 -0400
Subject: Re: [PATCH 1/1] kthreads: allow_signal: don't play with ->blocked
From: Matt Fleming <matt@console-pimps.org>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110817072746.GI4254@htj.dyndns.org>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
	 <1313071035-12047-42-git-send-email-matt@console-pimps.org>
	 <20110816180644.GJ29190@redhat.com> <20110816194427.GA6602@redhat.com>
	 <20110816194450.GB6602@redhat.com> <20110816195121.GG2803@mtj.dyndns.org>
	 <1313531422.3436.218.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20110817072746.GI4254@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 10:56:54 +0100
Message-ID: <1313575014.3436.233.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 09:27 +0200, Tejun Heo wrote:
> Hello,
> 
> On Tue, Aug 16, 2011 at 10:50:22PM +0100, Matt Fleming wrote:
> > 
> > But because daemonize() is exported by the kernel should it go through
> > the Documentation/feature-removal-schedule.txt procedure? And if so, can
> > the allow_signal() patch still go in before daemonize() is removed?
> 
> IMHO, not really.  APIs get modified and dropped all the time and only
> small fraction goes through feature-removal-schedule.  For APIs which
> are widely used and/or difficult to migrate from, it sure makes sense
> to do the staged removal but in this case it's an interface which is
> quite unpopular and with relatively easy workaround (just use
> kthread).
> 
> The worst thing we can do regarding API change is silently changing
> semantics while not changing the interface.  For this patchset I don't
> think it would matter all that much but is going that route.
> ie. allow_signal() behavior is proposed to be changed because
> in-kernel daemonize() users don't depend on it while leaving
> daemonize() alone.  This is much worse than simply removing
> daemonize() with sufficient explanation in the commit message.
> Out-of-kernel user which depended on the combination working would now
> be left with code which compiles fine but behaves differently, which
> sucks big time.
> 
> These changes _are_ related and interdependent, and routing these
> small changes through different trees often end up delaying things
> unnecessarily.  One subsystem maintainer forgets to apply a patch or
> send pull request and it can get easily drawn out half a year and
> people forget what the original change was about after a while often
> leading to half done conversions.  So, let's please collect all the
> related patches into one series, drop all in-kernel daemonize() users,
> kill daemonize() and then change allow_signal() behavior.

OK, that makes a lot of sense to me. Thanks for the rationale.

Oleg, feel to carry over my Acked-by's for the patches you've already
posted if you decide to go ahead with Tejun's plan.

-- 
Matt Fleming, Intel Open Source Technology Center

