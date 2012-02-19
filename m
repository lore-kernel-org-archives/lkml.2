Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab2BSJZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 04:25:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab2BSJZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 04:25:20 -0500
Date: Sun, 19 Feb 2012 11:24:56 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, John Stultz <johnstul@us.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/1] linux headers: header file(s) changes to enable
 spinlock use jumplabel
Message-ID: <20120219092456.GB10038@redhat.com>
References: <20120217082527.15283.72980.sendpatchset@oc5400248562.ibm.com>
 <4F403268.7040804@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F403268.7040804@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 03:21:12PM -0800, Jeremy Fitzhardinge wrote:
> On 02/17/2012 12:25 AM, Raghavendra K T wrote:
> > From:  Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> >
> > Changelog:
> >   Reordering in header files and adding declarations to enable
> >  spinlock header to use jump label technique.
> >     
> > Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> > ---
> >  I was re-basing Jermey patches (https://lkml.org/lkml/2011/10/12/496), while working
> > on paravirtualized ticket spinlock (3.3.-rc3).
> >
> > Currently <jump_label.h> includes <workqueue.h> (commit: b202952075f62603bea9bfb6ebc6b0420db11949)
> >
> >  So we get following error when we try to include jump_label.h from
> > arch/x86/include/asm/spinlock.h because of cyclic dependency
> > <spinlock.h> -> <jumplabe.h> -> <workque.h> -> ... <seqlock.h> -> <spinlock.h>
> 
> What about splitting the jump_label_key_deferred stuff into a separate
> jump_label_deferred.h, and just include that where it's needed?
> 
Andrew Jones did exactly that (CCed). But does pvlock have to use jump
label? I looked at the code and it is used like paravirt patching. Meaning
it is patched only once on a boot up when XEN is detected. May be use
paravirt patching instead of jump label? What if jump label will want
to use spinlock for some reason in the future (it uses mutex currently)?

--
			Gleb.
