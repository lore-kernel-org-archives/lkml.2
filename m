Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab1KOMXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 07:23:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36688 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab1KOMX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 07:23:27 -0500
X-Authority-Analysis: v=2.0 cv=KcRQQHkD c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=T0wpcEwfL4QA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=Y6Ls0il8xYNRf_uL0AsA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 2/2] Compile error with allmodconfig and
 CONFIG_PREEMPT_RT_FULL=y
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <efault@gmx.de>
Cc: John Kacur <jkacur@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1321334539.6347.43.camel@marge.simson.net>
References: <1321235083-21756-1-git-send-email-jkacur@redhat.com>
	 <1321235083-21756-2-git-send-email-jkacur@redhat.com>
	 <20111114165148.GB2372@linux.vnet.ibm.com>
	 <alpine.LFD.2.00.1111141837100.6707@localhost6.localdomain6>
	 <1321303871.5011.6.camel@frodo> <1321334539.6347.43.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Nov 2011 07:23:22 -0500
Message-ID: <1321359802.4181.1.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 06:22 +0100, Mike Galbraith wrote:

> > If we go that route, we might as well make everything
> > EXPORT_SYMBOL_GPL(), and be damn to those that use nVidia.
> 
> EXPORT_SYMBOL_GPL(migrate_disable) alone screws nVidia users, no?
> 
> I have an RT user who has no other viable choice than nVidia.  If the
> above is true, that user will end up stuck at 2.6.33-rt until we get a
> driver that actually works... or they deem linux to be a non-solution.

Right, migrate_disable() should not have been an EXPORT_SYMBOL_GPL(), as
it is a helper functions that is also exported as EXPORT_SYMBOL(). It
shouldn't be called directly anyway, even by code in the kernel proper.

-- Steve


