Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab1IMS7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:59:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:41675 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab1IMS7r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:59:47 -0400
Subject: RE: [ia64] Question on __ARCH_WANT_UNLOCKED_CTXSW
From: Peter Zijlstra <peterz@infradead.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ken Chen <kenchen@google.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>
Date: Tue, 13 Sep 2011 20:59:21 +0200
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301EA611910@orsmsx505.amr.corp.intel.com>
References: <1314188833.6925.3.camel@twins>
	 <987664A83D2D224EAE907B061CE93D5301EA611910@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315940361.4226.17.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 13:46 -0700, Luck, Tony wrote:
> > happen to remember what the perceived benefit of using
> > __ARCH_WANT_UNLOCKED_CTXSW was about?
> 
> No - digging around the code hasn't rung any bells for me either.
> 
> Perhaps just general goodness for not holding a lock for
> longer than we need to?  But that would imply some case where
> someone else could do something useful by being able to grab
> the lock when we drop it. About the only thing I can think
> of is that it would allow tasks to be re-balanced just a
> teeny bit earlier --- but re-balancing ought to be somewhat
> rare, yes?

Mostly yes, except remote wakeups, however that got a complete overhaul
in 3.0. Instead of taking the remote rq->lock we now enqueue the task on
a list and IPI the thing, then let the IPI do the remote enqueue and
trigger the reschedule.

So it might make sense to re-evaluate this on ia64 like Ken suggested..
then again, who has a large ia64 box and is still willing to put time
in? 
