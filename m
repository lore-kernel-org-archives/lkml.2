Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab1I3PbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:31:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:53072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab1I3PbK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:31:10 -0400
Subject: Re: [RFC][PATCH 4/5] signal: Add signal->ctrl_lock for job control
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anirudh Badam <abadam@cs.princeton.edu>
Date: Fri, 30 Sep 2011 17:30:27 +0200
In-Reply-To: <1317395577-14091-5-git-send-email-matt@console-pimps.org>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
	 <1317395577-14091-5-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317396627.12973.7.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 16:12 +0100, Matt Fleming wrote:
> +       assert_spin_locked(&t->sighand->siglock);
> +       assert_spin_locked(&t->signal->ctrl_lock);

There's also lockdep_assert_held(), the difference is that
assert_spin_locked() will always generate code, and only checks that the
lock is held, not that we are the current owner.

lockdep_assert_held() will only generate code for lockdep kernels and
will in fact check that the specified lock is held by the current task.
