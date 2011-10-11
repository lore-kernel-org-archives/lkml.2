Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1JKCcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 22:32:07 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57628 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752750Ab1JKCcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 22:32:06 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/UW5ZiacTU9+/AeJ1JGhS/buKqsw3xBV1H+EMK25
	/NR1GYKaRRxWmD
Subject: Re: [patch] cpusets, cgroups: disallow attaching kthreadd
From: Mike Galbraith <efault@gmx.de>
To: Tejun Heo <htejun@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20111010164339.GA8100@google.com>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	 <1316770936.6641.11.camel@marge.simson.net>
	 <1316775204.7562.9.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
	 <1316788392.6544.33.camel@marge.simson.net>
	 <1318224892.6161.45.camel@marge.simson.net>
	 <1318233815.6527.5.camel@marge.simson.net>
	 <20111010164339.GA8100@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 04:31:58 +0200
Message-ID: <1318300318.6329.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 09:43 -0700, Tejun Heo wrote:

> Yes, I think we need something like this.  wq workers were using
> PF_THREAD_BOUND to prevent diddling from userland which made some
> unhappy.  Maybe we need a flag to properly indicate "don't diddle with
> this thread from userland"?  But, then, mainline kernel wouldn't need
> the current PF_THREAD_BOUND at all.  Peter, Steven, what do you think?

Yeah, I was also thinking that there should really be a generic "I'm not
yours to play with" flag.  This just closes two cases I've run into
regarding kthreadd, there may be others where the user needs to know
implementation details to not shoot self in foot.

	-Mike

