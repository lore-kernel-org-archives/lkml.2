Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1ARXNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 18:13:45 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:58044 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1ARXNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 18:13:44 -0500
Subject: Re: [PATCH] Switch proc interfaces in kernel/ to %pK
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20110118225205.GA4601@p183.telecom.by>
References: <1295391078.1831.21.camel@dan>
	 <20110118225205.GA4601@p183.telecom.by>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 18:13:42 -0500
Message-ID: <1295392422.1831.29.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 00:52 +0200, Alexey Dobriyan wrote:
> On Tue, Jan 18, 2011 at 05:51:18PM -0500, Dan Rosenberg wrote:
> > Switch users of %p in /proc interfaces in kernel/ to %pK, to allow
> > configuring the level of exposure of kernel pointers via the
> > kptr_restrict sysctl.
> 
> > --- a/kernel/lockdep_proc.c
> > +++ b/kernel/lockdep_proc.c
> 
> /proc/lockdep is r--------
> /proc/lockdep_chains is r--------
> /proc/lock_stat is rw-------
> 
> Is this supposed to mean something?

It's certainly not a priority to switch these particular interfaces over
since they aren't exposed to unprivileged users.  However, when
kptr_restrict is set to 2, kernel pointers aren't exposed at all, even
to root.  Changing to %pK will certainly have no negative effect with
the default setting of 1 (hide when the reader does not have
CAP_SYSLOG).

Let me know if you're opposed and I can re-send a version that doesn't
touch these files.

