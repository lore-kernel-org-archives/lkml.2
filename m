Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab1JDRoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:44:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932703Ab1JDRoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:44:15 -0400
Date: Tue, 4 Oct 2011 19:39:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matt Fleming <matt@console-pimps.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Mosberger-Tang <davidm@egauge.net>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
Message-ID: <20111004173936.GC3489@redhat.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org> <m21uuxirxi.fsf@firstfloor.org> <1317461738.3375.46.camel@mfleming-mobl1.ger.corp.intel.com> <CA+55aFyscb=PcUDrEUhFbH89+W-KYEKrqKHeNN3dqmZD1GF_Hw@mail.gmail.com> <1317656613.3375.78.camel@mfleming-mobl1.ger.corp.intel.com> <20111003163559.GA3957@redhat.com> <1317675520.3375.82.camel@mfleming-mobl1.ger.corp.intel.com> <alpine.LFD.2.02.1110032345050.1489@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1110032345050.1489@ionos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Thomas Gleixner wrote:
>
> The main nuisance of sighand->siglock is the exit race protection and
> that's why we need to take it for evrything and some more.
>
> In order to distangle the posix-(cpu)-timer and other stuffs
> protection from that single lock, you need to introduce "independent"
> locks

Yes. And there is another (much more important imho) reason.

We need a separate lock to protect thread_group/children to avoid
tasklist_lock in exit_notify/wait/etc. And probably it should be
sleepable.

Oleg.

