Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab1JDR4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:56:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933203Ab1JDR4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:56:35 -0400
Date: Tue, 4 Oct 2011 19:52:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Matt Fleming <matt@console-pimps.org>, Tejun Heo <htejun@gmail.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
Message-ID: <20111004175235.GD3489@redhat.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org> <20110930165206.GA22048@redhat.com> <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com> <20110930235625.GD2658@mtj.dyndns.org> <1317464192.3375.57.camel@mfleming-mobl1.ger.corp.intel.com> <1317474209.12973.15.camel@twins> <20111003130701.GB25952@redhat.com> <1317655320.20367.25.camel@twins> <20111004171437.GA3489@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004171437.GA3489@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Oleg Nesterov wrote:
>
> On 10/03, Peter Zijlstra wrote:
> >
> > Right, so the thing Thomas and I have been promoting for a while now is
> > to update a signal target vector on every signal mask update. Mask
> > updates should be the slow path. This would leave us with a ready target
> > in O(1).
>
> Yes. This is the "obvious" solution ;) Now that we have
> set_current_blocked() this is simple. Except, of course, this blows
> signal_struct and set_current_blocked() can't rely on TIF_SIGPENDING.
> But we can probably add TIF_YOU_ARE_LISTED_IN_CURR_TARGET_ARRAY.

Forgot to mention... Unblocking becomes "nontrivial" too. But almost
all these changes are local to set_current_blocked().

Oleg.

