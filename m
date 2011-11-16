Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab1KPOVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:21:52 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:42969 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757759Ab1KPOVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:21:50 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+cUk0uC+icRp29jyxIhawKNB5zCMroJTYBkI/jne
	cbNal5JSzRtQDI
Subject: Re: [PATCH 2/2] Compile error with allmodconfig and
 CONFIG_PREEMPT_RT_FULL=y
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: John Kacur <jkacur@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1321363643.9105.13.camel@marge.simson.net>
References: <1321235083-21756-1-git-send-email-jkacur@redhat.com>
	 <1321235083-21756-2-git-send-email-jkacur@redhat.com>
	 <20111114165148.GB2372@linux.vnet.ibm.com>
	 <alpine.LFD.2.00.1111141837100.6707@localhost6.localdomain6>
	 <1321303871.5011.6.camel@frodo> <1321334539.6347.43.camel@marge.simson.net>
	 <1321359802.4181.1.camel@frodo> <1321363643.9105.13.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 15:21:45 +0100
Message-ID: <1321453305.15820.25.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 14:27 +0100, Mike Galbraith wrote:
> On Tue, 2011-11-15 at 07:23 -0500, Steven Rostedt wrote:
> 
> > Right, migrate_disable() should not have been an EXPORT_SYMBOL_GPL(), as
> > it is a helper functions that is also exported as EXPORT_SYMBOL(). It
> > shouldn't be called directly anyway, even by code in the kernel proper.
> 
> Ah.  Doesn't matter though.  I downloaded their latest, tried to build
> it with EXPORT_SYMBOL(migrate_enable/disable) ..
> 
> FATAL: modpost: GPL-incompatible module nvidia.ko uses GPL-only symbol '__rt_mutex_init'
> 
> With that exported, the thing builds and runs, but rt_mutex_foo exports
> appear to be intentionally GPL only, so it's "go fish" for nVidia.

Bah.  I checked the crusty old hack for crusty old driver, and it still
works just fine with a trivial define.  It'd probably work better if it
didn't need cheezy raw_* hacks, but then it'd probably work better if it
was GPL too ;-)

	-Mike

