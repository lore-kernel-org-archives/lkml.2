Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab1I3PgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:36:21 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38043 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755742Ab1I3PgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:36:19 -0400
Subject: Re: [RFC][PATCH 4/5] signal: Add signal->ctrl_lock for job control
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anirudh Badam <abadam@cs.princeton.edu>
In-Reply-To: <1317396627.12973.7.camel@twins>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
	 <1317395577-14091-5-git-send-email-matt@console-pimps.org>
	 <1317396627.12973.7.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 16:36:16 +0100
Message-ID: <1317396976.3375.23.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 17:30 +0200, Peter Zijlstra wrote:
> On Fri, 2011-09-30 at 16:12 +0100, Matt Fleming wrote:
> > +       assert_spin_locked(&t->sighand->siglock);
> > +       assert_spin_locked(&t->signal->ctrl_lock);
> 
> There's also lockdep_assert_held(), the difference is that
> assert_spin_locked() will always generate code, and only checks that the
> lock is held, not that we are the current owner.
> 
> lockdep_assert_held() will only generate code for lockdep kernels and
> will in fact check that the specified lock is held by the current task.

Aha! Yes, that's what I want, not assert_spin_locked(). Thanks!

-- 
Matt Fleming, Intel Open Source Technology Center

