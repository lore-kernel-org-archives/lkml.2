Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347Ab0DBIBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 04:01:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:37661 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759263Ab0DBIBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 04:01:03 -0400
Subject: Re: [REGRESSION 2.6.30][PATCH 1/1] sched: defer idle accounting
 till after load update period
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chase Douglas <chase.douglas@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
In-Reply-To: <alpine.LFD.2.00.1004012203270.32352@localhost.localdomain>
References: <1269870072-22449-1-git-send-email-chase.douglas@canonical.com>
	 <1269870072-22449-2-git-send-email-chase.douglas@canonical.com>
	 <20100401122740.a1ae80a7.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1004012133570.32352@localhost.localdomain>
	 <h2s40ec3ea41004011300zaa5699f0kcf07434fec9b1aab@mail.gmail.com>
	 <alpine.LFD.2.00.1004012203270.32352@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 02 Apr 2010 09:59:44 +0200
Message-ID: <1270195184.5109.523.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 22:18 +0200, Thomas Gleixner wrote:
> Well, the uninterruptible count imbalance is preventing us to calc the
> load avg per cpu, which is something the power saving folks are
> interested in.
> 
> If that is fixed we probably have a good chance to collect the per cpu
> stuff and build a combined one - have not looked into the gory details
> of the math yet.

The problem with all this per-cpu loadavg is that it would require a
steady tick on each cpu to age this loadavg, which is quite in
contradiction with power savings as they rather like the nohz feature.

No idea yet on what to do about that.
