Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab1E3NKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:10:49 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45487 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751573Ab1E3NKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:10:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18PqX5IrU8PwYtP/mI5yzLx5bMJGiIRmYyP/tTXcR
	E9IqWCS5WmvNEi
Subject: Re: Very high CPU load when idle with 3.0-rc1
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Damien Wyart <damien.wyart@free.fr>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1306755291.1200.2872.camel@twins>
References: <20110530055924.GA9169@brouette>
	 <1306755291.1200.2872.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 15:10:43 +0200
Message-ID: <1306761043.7415.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 13:34 +0200, Peter Zijlstra wrote:
> On Mon, 2011-05-30 at 07:59 +0200, Damien Wyart wrote:
> > Hi,
> > 
> > Testing 3.0-rc1 on a core i7 (4 cores + HT), I get a load average of 9.0
> > when idle. No process is shown running or in "D state" in htop. The box
> > is behaving normal, no impression of lag or slowness.
> > 
> > Not sure what other info to include, I guess this should be quite easy
> > to reproduce.
> 
> 
> ---
> Subject: rcu: Cure load woes
> 
> Commit cc3ce5176d83 (rcu: Start RCU kthreads in TASK_INTERRUPTIBLE
> state) fudges a sleeping task' state, resulting in the scheduler seeing
> a TASK_UNINTERRUPTIBLE task going to sleep, but a TASK_INTERRUPTIBLE
> task waking up. The result is unbalanced load calculation.

(darn, 'which' poked me in the eye, but 'how' didn't)

Yup, all better.

	-Mike

